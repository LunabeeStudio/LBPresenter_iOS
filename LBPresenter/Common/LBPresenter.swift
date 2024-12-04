//
//  LBPresenter.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import SwiftUI

/// A generic presenter that handles state and effects for a SwiftUI view using a reducer pattern.
final class LBPresenter<State: PresenterState>: ObservableObject {

    /// Type alias for the reducer function that handles state transitions and produces side effects.
    typealias Reducer = (_ state: State, _ action: State.Action) -> (State, Effect<State.Action>)

    /// The current state of the presenter, published to notify SwiftUI views of any changes.
    /// The state is `private(set)` to restrict modifications to the presenter logic only.
    @Published private(set) var state: State

    /// The reducer function used to compute the next state and potential side effects based on an action.
    private let reducer: Reducer

    /// A reference to the currently running effect task, used to manage cancellable async operations.
    private var currentEffectTask: Task<Void, Never>?

    /// Initializes the presenter with an initial state and a reducer.
    ///
    /// - Parameters:
    ///   - initialState: The initial state of the presenter.
    ///   - reducer: The reducer function that defines state transitions and handles side effects.
    init(initialState: State, reducer: @escaping Reducer) {
        state = initialState
        self.reducer = reducer
    }

    /// Sends an action to the presenter, updating the state and potentially executing a side effect.
    ///
    /// - Parameter action: The action to process through the reducer.
    @Sendable func send(_ action: State.Action) {
        let (newState, effect) = reducer(state, action)

        // Update the state only if it has changed to prevent unnecessary view updates.
        if (newState != state) {
            state = newState
        }

        // Handle the effect produced by the reducer.
        switch effect {
        case .none:
            break
        case .run(let asyncFunc):
            // Execute the async effect, providing a way to send follow-up actions.
            Task { await asyncFunc(send) }
        case .cancel:
            // Cancel any currently running effect task.
            currentEffectTask?.cancel()
        }
    }

    /// Sends an action to the presenter asynchronously, allowing the caller to await its completion.
    ///
    /// - Parameter action: The action to process through the reducer.
    @Sendable func send(_ action: State.Action) async {
        let (newState, effect) = reducer(state, action)

        // Update the state only if it has changed.
        if (newState != state) {
            state = newState
        }

        // Handle the effect produced by the reducer.
        switch effect {
        case .none:
            break
        case .run(let asyncFunc):
            // Execute the async effect within a cancellable task.
            await withTaskCancellationHandler {
                currentEffectTask = Task {
                    await asyncFunc { [weak self] action in
                        self?.send(action)
                    }
                }
                await currentEffectTask?.value
            } onCancel: {
                print("cancelled")
            }
        case .cancel:
            // Cancel the currently running effect task.
            currentEffectTask?.cancel()
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
