//
//  LBPresenter.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

@preconcurrency import Combine
import SwiftUI
import Foundation

@MainActor
/// A generic presenter that handles state and effects for a SwiftUI view using a reducer pattern.
final class LBPresenter<State: PresenterState>: ObservableObject {

    /// Type alias for the reducer function that handles state transitions and produces side effects.
    typealias Reducer = @MainActor (_ state: inout State, _ action: State.Action) -> Effect<State.Action>

    /// The current state of the presenter, published to notify SwiftUI views of any changes.
    /// The state is `private(set)` to restrict modifications to the presenter logic only.
    private(set) var state: State {
        willSet { updateState(newValue) }
    }

    /// The reducer function used to compute the next state and potential side effects based on an action.
    private let reducer: Reducer

    /// A reference to the currently running effect tasks, used to manage cancellable async operations.
    private let cancellationCancellables = CancellablesCollection()

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
        initialActions?.forEach { send($0) }
    }

    /// Sends an action to the presenter, updating the state and potentially executing a side effect.
    ///
    /// - Parameter action: The action to process through the reducer.
    func send(_ action: State.Action) {
        // Handle the effect produced by the reducer.
        switch reducer(&state, action)  {
        case .none:
            break
        case let .run(asyncFunc, cancelId):
            let task = Task {
                await asyncFunc { [weak self] action in
                    self?.send(action)
                }
            }
            let cancellable = AnyCancellable { task.cancel() }
            if cancelId != nil {
                cancellationCancellables.insert(cancellable, at: cancelId)
            }
        case let .cancel(cancelId):
            // Cancel the running effect task with the corresponding id.
            cancellationCancellables.cancel(id: cancelId)
        }
    }

    /// Sends an action to the presenter asynchronously, allowing the caller to await its completion.
    ///
    /// - Parameter action: The action to process through the reducer.
    func send(_ action: State.Action) async {
        // Handle the effect produced by the reducer.
        switch reducer(&state, action)  {
        case .none:
            break
        case let .run(asyncFunc, cancelId):
            let task = Task {
                await asyncFunc { [weak self] action in
                    self?.send(action)
                }
            }
            // Execute the async effect within a cancellable task.
            await withTaskCancellationHandler {
                let cancellable = AnyCancellable { task.cancel() }
                if cancelId != nil {
                    cancellationCancellables.insert(cancellable, at: cancelId)
                }
                defer {
                    if cancelId != nil {
                        cancellationCancellables.remove(cancellable, at: cancelId)
                    }
                }
                await task.value
            } onCancel: {
                // Cancel the currently running effect task.
                task.cancel()
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

/// optimisation to not retrigger when state isn't changed but is it really necessary ?
private extension LBPresenter {
    func updateState(_ newValue: State) {
        if state.isEqual(to: newValue) { return }
        objectWillChange.send()
    }
}
private extension PresenterState {
    func isEqual(to rhs: Self) -> Bool {
        guard let rhs = rhs as? any Equatable else { return false }
        guard let lhs = self as? any Equatable else { return false }
        return lhs.isEqual(to: rhs)
    }
}
private extension Equatable {
    func isEqual(to rhs: Any) -> Bool {
        if let rhs = rhs as? Self {
            return self == rhs
        } else {
            return false
        }
    }
}
