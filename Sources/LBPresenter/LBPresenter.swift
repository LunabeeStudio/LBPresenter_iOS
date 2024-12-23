//
//  LBPresenter.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import Combine
import SwiftUI
import Foundation

public protocol LBPresenterProtocol: ObservableObject {}

@MainActor
protocol LBNavPresenter: LBPresenterProtocol {
    func sendNavigation(navAction: any Actionning)
}

public protocol Actionning: Sendable, Equatable {}

/// A generic presenter that manages state, navigation, and effects for a SwiftUI view using a reducer pattern.
///
/// The presenter:
/// - Handles state changes and side effects through a reducer function.
/// - Supports navigation state management with a separate reducer.
/// - Provides mechanisms to send actions, manage child presenters, and create bindings for UI synchronization.
///
/// Conforms to `LBPresenterProtocol` and is designed to work seamlessly with SwiftUI's `ObservableObject` system.
@MainActor
public final class LBPresenter<State: Actionnable, NavState: NavPresenterState>: LBNavPresenter {
    /// A collection of child presenters for managing nested state and logic.
    var children: [NavState.Path: any LBPresenterProtocol] = [:]
    private weak var parent: (any LBNavPresenter)?

    /// The current state of the presenter, published to notify SwiftUI views of changes.
    ///
    /// State changes trigger updates in SwiftUI views observing this presenter.
    /// Modifications to the state are restricted to the presenter logic via the reducer.
    public private(set) var state: State {
        willSet {
            // Notify subscribers only when the new value differs from the old value.
            objectWillChange.send(with: newValue, oldValue: state)
        }
    }

    /// The navigation state managed by the presenter.
    ///
    /// This is used for handling navigation-specific logic. It is force-unwrapped to ensure
    /// initialization when needed.
    private(set) var navState: NavState! {
        didSet {
            // Notify subscribers when navigation state changes.
            objectWillChange.send()

            var validDestinations: [NavState.Path] = [navState.path]
            var subDestinations = navState.path

            // Generate all sub-paths by successively removing the last element
            while !subDestinations.isEmpty {
                subDestinations.removeLast()
                validDestinations.append(subDestinations)
            }

            // Filter the `children` dictionary
            children = children.filter { key, _ in
                validDestinations.contains(key)
            }
        }
    }

    /// The reducer function responsible for handling state transitions and side effects.
    let reducer: Reducer<State, NavState>

    /// The reducer function responsible for managing navigation-specific logic.
    let navReducer: NavReducer<NavState>!

    /// A collection to manage cancellable async operations tied to effect execution.
    private let cancellationCancellables: CancellablesCollection = .init()

    // MARK: - Initializers

    /// Initializes the presenter with an initial state, optional initial actions, and a reducer function.
    ///
    /// - Parameters:
    ///   - initialState: The initial state of the presenter, representing the starting point of the app's logic.
    ///   - initialActions: A list of actions to be dispatched immediately after initialization, allowing setup tasks.
    ///   - reducer: The reducer function to handle state transitions and produce effects.
    public init(initialState: State, initialActions: [State.Action]? = nil, reducer: Reducer<State, NavState>) {
        state = initialState
        self.reducer = reducer
        self.navState = nil
        self.navReducer = nil
        initialActions?.forEach { send($0) }
    }

    /// Initializes the presenter with navigation state and navigation reducer.
    ///
    /// - Parameters:
    ///   - initialState: The initial state of the presenter.
    ///   - initialActions: Optional initial actions to process during initialization.
    ///   - reducer: The reducer function for state transitions.
    ///   - navState: The initial navigation state.
    ///   - navReducer: The reducer function for navigation logic.
    public init(initialState: State, initialActions: [State.Action]? = nil, reducer: Reducer<State, NavState>, navState: NavState, navReducer: NavReducer<NavState>) {
        self.state = initialState
        self.reducer = reducer
        self.navState = navState
        self.navReducer = navReducer
        initialActions?.forEach { send($0) }
    }

    // MARK: - Methods

    /// Retrieves or creates a child presenter to manage nested state and actions.
    ///
    /// - Parameters:
    ///   - state: The state for the child presenter.
    ///   - reducer: The reducer function for the child presenter.
    /// - Returns: A configured child presenter instance.
    public func getChild<ChildState: Actionnable>(
        for state: ChildState,
        and reducer: Reducer<ChildState, NavState>
    ) -> LBPresenter<ChildState, NavState> {
        let presenterToReturn: LBPresenter<ChildState, NavState>

        if let presenter = children[navState.path] as? LBPresenter<ChildState, NavState> {
            presenterToReturn = presenter
        } else {
            let presenter: LBPresenter<ChildState, NavState> = .init(initialState: state, reducer: reducer, navState: navState, navReducer: navReducer)
            presenter.parent = self
            children[navState.path] = presenter
            presenterToReturn = presenter
        }

        return presenterToReturn
    }

    /// Sends an action to the presenter, triggering state updates and effects.
    ///
    /// - Parameters:
    ///   - action: The action to process through the reducer.
    ///   - transaction: An optional `Transaction` to batch state changes with animations.
    public func send(_ action: State.Action, _ transaction: Transaction? = nil) {
        // Handle the effect produced by the reducer.
        let effect: Effect<State.Action, NavState.Action> = withTransaction(transaction ?? .init()) { reducer(&state, action) }
        switch effect {
        case .none:
            break
        case let .run(asyncFunc, cancelId):
            cancellationCancellables.cancel(id: cancelId)
            let task: Task<Void, Never> = Task { @MainActor in
                await asyncFunc(.init(send: { [weak self] action, transaction in
                    Task { @MainActor in
                        self?.send(action, transaction)
                    }
                }), .init(send: { [weak self] action, _ in
                    Task { @MainActor in
                        self?.sendNavigation(navAction: action)
                    }
                }))
            }
            let cancellable: AnyCancellable = .init { task.cancel() }
            cancellationCancellables.insert(cancellable, at: cancelId)
            Task { @MainActor in
                defer { cancellationCancellables.remove(cancellable, at: cancelId) }
                // Wait for the task to finish and clean up after completion
                _ = await task.result // Wait for the task to complete
            }
        case let .cancel(cancelId):
            // Cancel the running effect task with the corresponding id.
            cancellationCancellables.cancel(id: cancelId)
        }
    }

    /// Sends an action to the presenter asynchronously, allowing the caller to await its completion.
    ///
    /// - Parameter action: The action to process through the reducer.
    func send(_ action: State.Action, _ transaction: Transaction? = nil) async {
        // Handle the effect produced by the reducer.
        let effect: Effect<State.Action, NavState.Action> = withTransaction(transaction ?? .init()) { reducer(&state, action) }
        switch effect {
        case .none:
            break
        case let .run(asyncFunc, cancelId):
            let myCancelId: String = cancelId ?? UUID().uuidString
            await withTaskCancellationHandler {
                cancellationCancellables.cancel(id: myCancelId)
                let task: Task<Void, Never> = Task {
                    await asyncFunc(.init(send: { [weak self] action, transaction in
                        Task { @MainActor in
                            self?.send(action, transaction)
                        }
                    }), .init(send: { [weak self] action, _ in
                        Task { @MainActor in
                            self?.sendNavigation(navAction: action)
                        }
                    }))
                }
                let cancellable: AnyCancellable = .init { task.cancel() }
                cancellationCancellables.insert(cancellable, at: myCancelId)
                defer { cancellationCancellables.remove(cancellable, at: myCancelId) }
                // Wait for the task to finish and clean up after completion
                _ = await task.result // Wait for the task to complete
            } onCancel: {
                Task { @MainActor in
                    cancellationCancellables.cancel(id: myCancelId)
                }
            }
        case let .cancel(cancelId):
            // Cancel the running effect task with the corresponding id.
            cancellationCancellables.cancel(id: cancelId)
        }
    }

    /// Sends a navigation-specific action to the presenter.
    ///
    /// - Parameter navAction: The navigation action to process.
    func sendNavigation(navAction: any Actionning) {
        let previousPath: NavState.Path = navState.path
        if let parent {
            parent.sendNavigation(navAction: navAction)
        } else {
            navReducer(&navState, navAction)
        }
    }

    /// Creates a binding to synchronize a value with the UI and propagate changes back as actions.
    ///
    /// - Parameters:
    ///   - value: The current value to synchronize.
    ///   - action: A closure to create an action when the value changes.
    /// - Returns: A `Binding` instance connecting the value to the presenter logic.
    public func binding<Value>(
        for value: Value,
        send action: @escaping (Value) -> State.Action
    ) -> Binding<Value> {
        Binding(
            get: { value },
            set: { [weak self] newValue, _ in
                self?.send(action(newValue))
            }
        )
    }
}
