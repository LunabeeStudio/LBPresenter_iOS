//
//  LBPresenter.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import Combine
import SwiftUI
import Foundation

public protocol Actionning: Sendable, Equatable {}

/// A generic presenter that manages state, navigation, and effects for a SwiftUI view using a reducer pattern.
///
/// The presenter:
/// - Handles state changes and side effects through a reducer function.
/// - Supports navigation state management with a separate reducer.
/// - Provides mechanisms to send actions, manage child presenters, and create bindings for UI synchronization.
///
/// Conforms to `LBPresenterProtocol` and is designed to work seamlessly with SwiftUI's `ObservableObject` system.
public final class LBPresenter<State: Actionnable, NavState: NavPresenterState>: LBNavPresenter, LBSheetPresenter {
    /// A collection of child presenters for managing nested state and logic.
    ///
    /// Each child is uniquely identified by a `UUID` and is associated with a specific navigation path.
    /// This allows efficient tracking of child presenters, ensuring they can be updated or removed
    /// based on changes to the navigation state.
    private var children: [UUID: any LBPresenterProtocol] = [:]
    var presentedChild: (any LBPresenterProtocol)?

    /// A reference to the parent presenter, used to manage hierarchical navigation flows.
    ///
    /// The parent presenter can coordinate with its children to handle actions or propagate state changes.
    /// This is weak to avoid strong reference cycles.
    private weak var parent: (any LBNavPresenter)?

    private weak var sheetParent: (any LBPresenterProtocol & LBSheetPresenter)?
    
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

    /// The navigation state managed by this presenter.
    ///
    /// This state encapsulates the current navigation path and any associated logic.
    /// The `navState` is force-unwrapped because it must be initialized before use.
    /// When the state changes, subscribers are notified, and child presenters are updated or removed
    /// based on the presence of the UUID in the new value.
    private(set) var navState: NavState! {
        didSet {
            // Notify subscribers when navigation state changes.
            objectWillChange.send()

            let oldDestinations = Set(oldValue.path.compactMap { $0.uniqueId })
            let newDestinations = Set(navState.path.compactMap { $0.uniqueId })

            oldDestinations.subtracting(newDestinations).forEach { uuid in
                children.removeValue(forKey: uuid)
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
    /// This function either fetches an existing child presenter associated with the provided `uniqueId`
    /// or creates a new one if none exists. The child presenter is associated with the current navigation path
    /// and stored in the `children` collection.
    ///
    /// - Parameters:
    ///   - state: The initial state to be managed by the child presenter.
    ///   - reducer: The reducer function that defines how the child presenter will handle state changes.
    ///   - uniqueId: A unique identifier to associate the child presenter with this navigation flow.
    /// - Returns: A configured child presenter instance that manages the given `state` and responds to the `reducer`.
    public func getChild<ChildState: Actionnable>(
        for state: ChildState,
        and reducer: Reducer<ChildState, NavState>,
        bindTo uniqueId: UUID
    ) -> LBPresenter<ChildState, NavState> {
        let presenterToReturn: LBPresenter<ChildState, NavState>

        if let presenter = children[uniqueId] as? LBPresenter<ChildState, NavState> {
            presenterToReturn = presenter
        } else {
            let presenter: LBPresenter<ChildState, NavState> = .init(initialState: state, reducer: reducer, navState: navState, navReducer: navReducer)
            presenter.parent = self
            presenter.sheetParent = sheetParent
            children[uniqueId] = presenter
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
        case let .dismiss(all):
            all ? dismissAll() : dismiss()
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
        case .dismiss:
            dismiss()
        case let .cancel(cancelId):
            // Cancel the running effect task with the corresponding id.
            cancellationCancellables.cancel(id: cancelId)
        }
    }

    /// Sends a navigation-specific action to the presenter.
    ///
    /// - Parameter navAction: The navigation action to process.
    func sendNavigation(navAction: any Actionning) {
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

    @MainActor func dismissAll() {
        if let sheetParent {
            self.sheetParent?.presentedChild = nil
            sheetParent.dismiss()
        } else {
            state.dismiss()
        }
    }

    @MainActor func dismiss() {
        if let sheetParent, sheetParent.presentedChild === self {
            self.sheetParent?.presentedChild = nil
            sheetParent.dismiss()
        } else {
            state.dismiss()
        }
    }
}

public extension LBPresenter where State: SheetPresenterState {
    func getPresentedChild<ChildState: Actionnable, NavChildState: NavPresenterState>(
        for state: ChildState,
        reducer: Reducer<ChildState, NavChildState>,
        navState: NavChildState,
        navReducer: NavReducer<NavChildState>
    ) -> LBPresenter<ChildState, NavChildState> {
        let presenter: LBPresenter<ChildState, NavChildState> = .init(initialState: state, reducer: reducer, navState: navState, navReducer: navReducer)
        self.presentedChild = presenter
        presenter.sheetParent = self
        return presenter
    }

    func getPresentedChild<ChildState: Actionnable>(
        for state: ChildState,
        reducer: Reducer<ChildState, Never>
    ) -> LBPresenter<ChildState, Never> {
        let presenter: LBPresenter<ChildState, Never> = .init(initialState: state, reducer: reducer)
        self.presentedChild = presenter
        presenter.sheetParent = self
        return presenter
    }
}
