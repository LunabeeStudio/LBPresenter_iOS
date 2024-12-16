//
//  Send.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 11/12/2024.
//

import SwiftUI

/// A utility for dispatching actions to the system, typically used within effects.
///
/// The `Send` struct provides a way to send actions back into the system, enabling state updates
/// or triggering additional operations from asynchronous effects. It ensures that actions are
/// dispatched safely on the main actor and supports optional transaction handling for smoother
/// UI updates.
///
/// ## Example
/// ```swift
/// let effect: Effect<Action, NavigationAction> = .run { send, _ in
///     await Task.sleep(1_000_000_000) // Simulate async operation
///     send(.actionCompleted)          // Dispatch an action
/// }
/// ```
public struct Send<Action>: Sendable {

    /// The closure responsible for dispatching actions.
    let send: @MainActor (Action, Transaction?) -> Void

    /// Initializes a new `Send` instance with the given action dispatching logic.
    ///
    /// - Parameter send: A closure that handles dispatching actions on the main actor.
    public init(send: @escaping @MainActor (Action, Transaction?) -> Void) {
        self.send = send
    }

    /// Sends an action back into the system from an effect.
    ///
    /// This method dispatches an action without an associated transaction, typically used for
    /// actions that don't require fine-grained control over animation or UI updates.
    ///
    /// - Parameter action: The action to be dispatched.
    @MainActor public func callAsFunction(_ action: Action) {
        guard !Task.isCancelled else { return } // Avoid sending actions if the task is cancelled
        self.send(action, nil)
    }

    /// Sends an action back into the system from an effect with an associated transaction.
    ///
    /// Transactions allow you to coordinate state changes with animations or other UI updates,
    /// providing smoother transitions and better user experiences.
    ///
    /// - Parameters:
    ///   - action: The action to be dispatched.
    ///   - transaction: A `Transaction` object that encapsulates animation or update timing details.
    @MainActor public func callAsFunction(_ action: Action, transaction: Transaction) {
        guard !Task.isCancelled else { return } // Avoid sending actions if the task is cancelled
        self.send(action, transaction)
    }
}
