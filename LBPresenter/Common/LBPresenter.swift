//
//  LBPresenter.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import Combine
import SwiftUI
import Foundation

protocol LBPresenterProtocol: ObservableObject {}

@MainActor
/// A generic presenter that handles state and effects for a SwiftUI view using a reducer pattern.
final class LBPresenter<State: Actionnable, NavState: FlowPresenterState>: LBPresenterProtocol {
    var children: [any LBPresenterProtocol] = []

    /// The current state of the presenter, published to notify SwiftUI views of any changes.
    /// The state is `private(set)` to restrict modifications to the presenter logic only.
    private(set) var state: State {
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
    init(initialState: State, initialActions: [State.Action]? = nil, reducer: Reducer<State, NavState>) {
        state = initialState
        self.reducer = reducer
        self.navState = nil
        self.navReducer = nil
        initialActions?.forEach { send($0) }
    }

    init(initialState: State, initialActions: [State.Action]? = nil, reducer: Reducer<State, NavState>, navState: NavState, navReducer: NavReducer<NavState>) {
        self.state = initialState
        self.reducer = reducer
        self.navState = navState
        self.navReducer = navReducer
        initialActions?.forEach { send($0) }
    }

    func getChild<ChildState: Actionnable>(for state: ChildState, and reducer: Reducer<ChildState, NavState>) -> LBPresenter<ChildState, NavState> {
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
    func send(_ action: State.Action, _ transaction: Transaction? = nil) {
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

    private func send(navAction: NavState.Action) {
        navReducer(&navState, navAction)
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
    func binding<Value>(for value: Value, send action: @escaping (Value) -> State.Action) -> Binding<Value> {
        Binding(
            get: { value },
            set: { [weak self] newValue, _ in
                self?.send(action(newValue))
            }
        )
    }
}

extension LBPresenter where NavState.Path == [NavState.Destination] {
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
    func bindPath(send action: @escaping (NavState.Path.Element?) -> NavState.Action) -> Binding<NavState.Path> {
        Binding(
            // The getter for the binding returns the current value of the collection.
            get: { self.navState.path },
            // The setter for the binding updates the collection and triggers the `action` for the last element.
            set: { [weak self] newValue, _ in
                guard let self else { return }
                // Send the action associated with the last element to the `NavState`.
                var destination: NavState.Path.Element? = newValue.last
                if newValue.count < navState.path.count { destination = nil } // pop
                self.send(navAction: action(destination))
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
    func task<State: PresenterState, NavState: Actionnable>(_ presenter: LBPresenter<State, NavState>, action: State.Action) -> some View where State.Action: Sendable {
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
    func refreshable<State: PresenterState, NavState: Actionnable>(_ presenter: LBPresenter<State, NavState>, action: State.Action) -> some View where State.Action: Sendable {
        // The `.refreshable` modifier handles the pull-to-refresh gesture and executes asynchronous code.
        self.refreshable {
            await presenter.send(action)
        }
    }
}

// Extension to make the `Never` type conform to the `FlowPresenterState` protocol.
extension Never: FlowPresenterState {
    var path: Never {
        get { fatalError() }
        set {}
    }

    typealias Path = Never
    typealias Destination = Never
    typealias Action = Never
}
