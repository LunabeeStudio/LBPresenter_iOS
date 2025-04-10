//
//  LBSimplePresenter.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 10/04/2025.
//

import SwiftUI
import Combine

@MainActor
public final class LBSimplePresenter<State: PresenterState & Reducable & Sendable>: ObservableObject {
    /// The current state of the presenter, published to notify SwiftUI views of changes.
    ///
    /// State changes trigger updates in SwiftUI views observing this presenter.
    /// Modifications to the state are restricted to the presenter logic via the reducer.
    private var state: State {
        willSet {
            // Notify subscribers only when the new value differs from the old value.
            objectWillChange.send(with: newValue, oldValue: state)
        }
    }

    public var uiState: State.UiState { state.uiState }

    /// A collection to manage cancellable async operations tied to effect execution.
    private let cancellationCancellables: CancellablesCollection = .init()

    // MARK: - Initializers

    /// Initializes the presenter with an initial state, optional initial actions, and a reducer function.
    ///
    /// - Parameters:
    ///   - initialState: The initial state of the presenter, representing the starting point of the app's logic.
    ///   - initialActions: A list of actions to be dispatched immediately after initialization, allowing setup tasks.
    ///   - reducer: The reducer function to handle state transitions and produce effects.
    public init(initialState: State) {
        state = initialState
    }

    @MainActor public func callAsFunction(_ action: State.Action, _ transaction: Transaction? = nil) {
        // Handle the effect produced by the reducer.
        let effect: SimpleEffect<State.Action> = withTransaction(transaction ?? .init()) { State.reduce(&state, action) }
        switch effect {
        case .none:
            break
        case let .run(asyncFunc, cancelId):
            cancellationCancellables.cancel(id: cancelId)
            let task: Task<Void, Never> = Task { @MainActor in
                await asyncFunc(.init(send: { [weak self] action, transaction in
                    Task { @MainActor in
                        self?(action, transaction)
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
        let effect: SimpleEffect<State.Action> = withTransaction(transaction ?? .init()) { State.reduce(&state, action) }
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
                            await self?.send(action, transaction)
                        }
                    }))
                }
                let cancellable: AnyCancellable = .init { task.cancel() }
                cancellationCancellables.insert(cancellable, at: myCancelId)
                defer { cancellationCancellables.remove(cancellable, at: myCancelId) }
                // Wait for the task to finish and clean up after completion
                _ = await task.result // Wait for the task to complete
            } onCancel: { [weak self] in
                Task { @MainActor in
                    self?.cancellationCancellables.cancel(id: myCancelId)
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
                Task { await self?.send(action(newValue)) }
            }
        )
    }
}
