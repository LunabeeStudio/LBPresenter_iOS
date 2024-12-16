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
/// A generic presenter that handles state and effects for a SwiftUI view using a reducer pattern.
public final class LBPresenter<State: Actionnable, NavState: NavPresenterState>: LBPresenterProtocol {
    var children: [any LBPresenterProtocol] = []

    /// The current state of the presenter, published to notify SwiftUI views of any changes.
    /// The state is `private(set)` to restrict modifications to the presenter logic only.
    public private(set) var state: State {
        willSet { objectWillChange.send(with: newValue, oldValue: state) }
    }

    private(set) var navState: NavState! { // force unwrapped to force instantiation when needed
        didSet { objectWillChange.send() }
    }

    /// The reducer function used to compute the next state and potential side effects based on an action.
    let reducer: Reducer<State, NavState>
    let navReducer: NavReducer<NavState>! // force unwrapped to force instantiation when needed

    /// A reference to the currently running effect tasks, used to manage cancellable async operations.
    private let cancellationCancellables: CancellablesCollection = .init()
    private var cancellables: Set<AnyCancellable> = []

    /// Initializes the presenter with an initial state, a list of initial actions to process, and a reducer function.
    ///
    /// This initializer sets up the presenter's state and defines how it will handle actions using the provided reducer.
    /// It also processes any initial actions immediately after the state is initialized, allowing for early setup or
    /// state transitions as needed.
    ///
    /// - Parameters:
    ///   - initialState: The initial state of the presenter. This defines the starting point for state management
    ///     and represents the application's state before any actions are handled.
    ///   - initialActions: An optional list of actions to be dispatched immediately after initialization. These actions
    ///     allow for setup logic, such as fetching data or navigating to an initial screen.
    ///   - reducer: The reducer function that handles state transitions and defines any associated side effects.
    ///     The reducer determines how the state evolves in response to actions and can trigger additional
    ///     operations via effects.
    public init(initialState: State, initialActions: [State.Action]? = nil, reducer: Reducer<State, NavState>) {
        state = initialState
        self.reducer = reducer
        self.navState = nil
        self.navReducer = nil
        initialActions?.forEach { send($0) }
    }

    public init(initialState: State, initialActions: [State.Action]? = nil, reducer: Reducer<State, NavState>, navState: NavState, navReducer: NavReducer<NavState>) {
        self.state = initialState
        self.reducer = reducer
        self.navState = navState
        self.navReducer = navReducer
        initialActions?.forEach { send($0) }
    }

    public func getChild<ChildState: Actionnable>(for state: ChildState, and reducer: Reducer<ChildState, NavState>) -> LBPresenter<ChildState, NavState> {
        let presenter: LBPresenter<ChildState, NavState> = .init(initialState: state, reducer: reducer, navState: navState, navReducer: navReducer)
        children.append(presenter)
        presenter.objectWillChange
            .sink { [weak self] _ in
                self?.navState = presenter.navState
            }
            .store(in: &cancellables)
        return presenter
    }

    /// Sends an action to the presenter, updating the state and potentially executing a side effect.
    ///
    /// - Parameter action: The action to process through the reducer.
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
                        self?.send(navAction: action)
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

    func send(navAction: NavState.Action) {
        navReducer(&navState, navAction)
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
                            self?.send(navAction: action)
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

    /// Creates a binding to synchronize a value with the UI and propagate changes back as actions.
    ///
    /// - Parameters:
    ///   - value: The current value to be synchronized with the UI.
    ///   - action: A closure to convert the updated value into an action.
    /// - Returns: A `Binding` instance that connects the value and action.
    public func binding<Value>(for value: Value, send action: @escaping (Value) -> State.Action) -> Binding<Value> {
        Binding(
            get: { value },
            set: { [weak self] newValue, _ in
                self?.send(action(newValue))
            }
        )
    }
}
