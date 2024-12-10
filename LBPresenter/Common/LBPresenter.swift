//
//  LBPresenter.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import Combine
import SwiftUI
import Foundation

@MainActor
/// A generic presenter that handles state and effects for a SwiftUI view using a reducer pattern.
class LBPresenter<State: Actionnable, NavState: Actionnable>: ObservableObject {
    /// Type alias for the reducer function that handles state transitions and produces side effects.
    typealias Reducer = @MainActor (_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action>
    typealias NavReducer = @MainActor (_ navState: inout NavState, _ action: NavState.Action) -> Void

    /// The current state of the presenter, published to notify SwiftUI views of any changes.
    /// The state is `private(set)` to restrict modifications to the presenter logic only.
    private(set) var state: State {
        willSet { objectWillChange.send(with: newValue, oldValue: state) }
    }

    private(set) var navState: NavState! {
        willSet { objectWillChange.send(with: newValue, oldValue: navState) }
    } // force unwrapped to force instantiation when needed

    /// The reducer function used to compute the next state and potential side effects based on an action.
    let reducer: Reducer
    let navReducer: NavReducer! // force unwrapped to force instantiation when needed

    /// A reference to the currently running effect tasks, used to manage cancellable async operations.
    let cancellationCancellables: CancellablesCollection = .init()

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
    init(initialState: State, initialActions: [State.Action]? = nil, reducer: @escaping Reducer) {
        state = initialState
        self.reducer = reducer
        self.navState = nil
        self.navReducer = nil
        initialActions?.forEach { send($0) }
    }

    init(initialState: State, initialActions: [State.Action]? = nil, reducer: @escaping Reducer, navState: NavState, navReducer: @escaping NavReducer) {
        self.state = initialState
        self.reducer = reducer
        self.navState = navState
        self.navReducer = navReducer
        initialActions?.forEach { send($0) }
    }

    /// Sends an action to the presenter, updating the state and potentially executing a side effect.
    ///
    /// - Parameter action: The action to process through the reducer.
    func send(_ action: State.Action, _ transaction: Transaction? = nil) {
        // Handle the effect produced by the reducer.
        let effect: Effect<State.Action, NavState.Action> = withTransaction(transaction ?? .init()) { reducer(&state, action) }
        switch effect {
        case .none:
            break
        case let .run(asyncFunc, cancelId):
            cancellationCancellables.cancel(id: cancelId)
            let task: Task<Void, Never> = Task {
                await asyncFunc { [weak self] action, transaction in
                    self?.send(action, transaction)
                } _: { [weak self] action in
                    self?.send(action)
                }
            }
            let cancellable = AnyCancellable { task.cancel() }
            cancellationCancellables.insert(cancellable, at: cancelId)
            Task {
                defer { cancellationCancellables.remove(cancellable, at: cancelId) }
                // Wait for the task to finish and clean up after completion
                _ = await task.result // Wait for the task to complete
            }
        case let .cancel(cancelId):
            // Cancel the running effect task with the corresponding id.
            cancellationCancellables.cancel(id: cancelId)
        }
    }

    func send(_ action: NavState.Action) {
        navReducer(&navState, action)
    }

    /// Sends an action to the presenter asynchronously, allowing the caller to await its completion.
    ///
    /// - Parameter action: The action to process through the reducer.
    fileprivate func send(_ action: State.Action, _ transaction: Transaction? = nil) async {
        // Handle the effect produced by the reducer.
        let effect: Effect<State.Action, NavState.Action> = withTransaction(transaction ?? .init()) { reducer(&state, action) }
        switch effect {
        case .none:
            break
        case let .run(asyncFunc, cancelId):
            cancellationCancellables.cancel(id: cancelId)
            let task: Task<Void, Never> = Task {
                await asyncFunc { [weak self] action, transaction in
                    self?.send(action, transaction)
                } _: { [weak self] action in
                    self?.send(action)
                }
            }
            let cancellable = AnyCancellable { task.cancel() }
            cancellationCancellables.insert(cancellable, at: cancelId)
            defer { cancellationCancellables.remove(cancellable, at: cancelId) }
            // Wait for the task to finish and clean up after completion
            _ = await task.result // Wait for the task to complete
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
    func binding<Value>(for value: Value, send action: @escaping (Value) -> State.Action) -> Binding<Value> {
        Binding(
            get: { value },
            set: { [weak self] newValue, _ in
                self?.send(action(newValue))
            }
        )
    }

    /// Creates a SwiftUI `Binding` that observes and updates a bidirectional collection
    /// while sending an action whenever the collection's last element changes.
    ///
    /// - Parameters:
    ///   - value: The current value of the collection to bind to. Must conform to `BidirectionalCollection`.
    ///   - action: A closure that takes the last element of the collection as input
    ///             and returns an action of type `NavState.Action`.
    ///
    /// - Returns: A `Binding` for the given collection that updates its value and triggers an action when its last element changes.
    ///
    /// - Note:
    ///   This binding only reacts to changes in the last element of the collection.
    ///   The `action` is triggered only when the collection's `last` property is updated.
    func binding<Value: BidirectionalCollection>(
        for value: Value,
        send action: @escaping (Value.Element) -> NavState.Action
    ) -> Binding<Value> where Value.Element: Hashable {
        Binding(
            // The getter for the binding returns the current value of the collection.
            get: { value },
            // The setter for the binding updates the collection and triggers the `action` for the last element.
            set: { [weak self] newValue, _ in
                // Safely unwrap the last element of the new collection.
                if let lastElement = newValue.last {
                    // Send the action associated with the last element to the `NavState`.
                    self?.send(action(lastElement))
                }
            }
        )
    }
}

// Extension to ObservableObjectPublisher to add a helper method for conditional publishing
private extension ObservableObjectPublisher {
    /// Sends an update to notify subscribers of changes only if the new value is different from the old value.
    ///
    /// - Parameters:
    ///   - newValue: The new value of a type conforming to the `Actionnable` protocol.
    ///   - oldValue: The previous value of the same type.
    ///
    /// This method uses the `isEqual(to:)` method from the `Actionnable` protocol to compare the old and new values.
    /// If they are equal, no notification is sent to avoid unnecessary updates. Otherwise, it triggers a change notification.
    func send<T: Actionnable>(with newValue: T, oldValue: T) {
        // Check if the old and new values are equal using the `isEqual(to:)` method.
        if oldValue.isEqual(to: newValue) {
            // If the values are equal, no changes have occurred, so exit without sending a notification.
            return
        }
        // If the values are different, notify all subscribers of the change.
        send()
    }
}

private extension Actionnable {
    /// Compares two states for equality.
    ///
    /// - Parameter rhs: The other state to compare to.
    /// - Returns: `true` if the states are considered equal, `false` otherwise.
    func isEqual(to rhs: Self) -> Bool {
        // Check if both states conform to `Equatable` and compare them directly.
        if let lhs = self as? any Equatable,
           let rhs = rhs as? any Equatable {
            return lhs.isEqual(to: rhs)
        }
        // If not `Equatable`, assume they are different.
        return false
    }
}

private extension Equatable {
    /// Compares this instance to another using dynamic type casting.
    ///
    /// - Parameter rhs: The other value to compare to.
    /// - Returns: `true` if the values are equal, `false` otherwise.
    func isEqual(to rhs: Any) -> Bool {
        guard let rhs = rhs as? Self else { return false }
        return self == rhs
    }
}

// Extension to the View protocol to add custom task and refreshable modifiers
extension View {
    /// Attaches an asynchronous task to the view that sends an action to the presenter.
    ///
    /// This task is triggered when the view appears. It's a specialized version of the `.task` modifier,
    /// designed for use with an `LBPresenter` that manages state and navigation actions.
    ///
    /// - Parameters:
    ///   - presenter: The `LBPresenter` responsible for managing the state and sending actions.
    ///   - action: The action of type `State.Action` to send to the presenter when the task executes.
    /// - Returns: A view with the task attached.
    func task<State: PresenterState, NavState: Actionnable>(
        _ presenter: LBPresenter<State, NavState>,
        action: State.Action
    ) -> some View where State.Action: Sendable {
        // The `.task` modifier allows asynchronous code to run when the view appears.
        self.task {
            await presenter.send(action)
        }
    }

    /// Adds a pull-to-refresh interaction to the view that sends an action to the presenter.
    ///
    /// This modifier is triggered when the user performs a "pull-to-refresh" gesture.
    /// It's a specialized version of the `.refreshable` modifier, tailored for use with an `LBPresenter`.
    ///
    /// - Parameters:
    ///   - presenter: The `LBPresenter` responsible for managing the state and sending actions.
    ///   - action: The action of type `State.Action` to send to the presenter when the refresh is triggered.
    /// - Returns: A view with the refreshable behavior attached.
    func refreshable<State: PresenterState, NavState: Actionnable>(
        _ presenter: LBPresenter<State, NavState>,
        action: State.Action
    ) -> some View where State.Action: Sendable {
        // The `.refreshable` modifier handles the pull-to-refresh gesture and executes asynchronous code.
        self.refreshable {
            await presenter.send(action)
        }
    }
}

// Extension to make the `Never` type conform to the `Actionnable` protocol.
extension Never: Actionnable {
    /// The `Action` associated type for `Never` is also `Never`,
    /// since `Never` represents a type that cannot have any instances.
    ///
    /// This is useful for cases where no navigation actions are needed.
    typealias Action = Never
}

/// A wrapper for a generic `send` function to safely handle type-erased actions.
/// This wrapper is `Sendable` to ensure thread-safety in Swift's concurrency model.
struct SendFunctionWrapper: Sendable {
    // A private closure that handles sending type-erased actions.
    // It accepts `Any` and validates the type before forwarding it.
    private let _send: @MainActor (Any) -> Void

    /// Initializes the wrapper with a strongly-typed `send` function.
    /// The closure is type-erased to handle any input conforming to the expected action type.
    /// - Parameter send: A closure to process actions of a specific type.
    init<Action>(send: @escaping @MainActor (Action) -> Void) {
        self._send = { anyValue in
            // Ensure the value is of the expected `Action` type before sending.
            guard let value = anyValue as? Action else {
                assertionFailure("Type mismatch: Expected \(Action.self), got \(type(of: anyValue))")
                return
            }
            send(value)
        }
    }

    /// Sends an action of a specific type to the underlying closure.
    /// - Parameter value: The action to send.
    @MainActor func send<Action>(_ value: Action) {
        _send(value)
    }
}

/// A private environment key for storing the `SendFunctionWrapper`.
/// This key allows the wrapper to be passed through SwiftUI's environment.
private struct SendEnvironmentKey: EnvironmentKey {
    // The default value for the environment key is `nil` because no wrapper exists initially.
    static let defaultValue: SendFunctionWrapper? = nil
}

extension EnvironmentValues {
    /// A computed property to access or set the `SendFunctionWrapper` in the environment.
    var navigationContext: SendFunctionWrapper? {
        get { self[SendEnvironmentKey.self] }
        set { self[SendEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// Sets up the navigation context in the SwiftUI environment.
    /// This allows child views to access the `SendFunctionWrapper` for navigation actions.
    /// - Parameter presenter: The presenter providing the `send` function to handle navigation actions.
    /// - Returns: A view modified with the navigation context environment value.
    func setNavigationContext<State, NavState>(with presenter: LBPresenter<State, NavState>) -> some View {
        self.environment(\.navigationContext, SendFunctionWrapper(send: presenter.send(_:)))
    }
}
