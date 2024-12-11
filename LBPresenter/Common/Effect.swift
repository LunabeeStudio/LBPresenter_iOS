//
//  Effect.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import SwiftUI

typealias SendNavigation<Action> = @Sendable @MainActor (_ action: Action) -> Void

@MainActor
public struct Send<Action>: Sendable {
    let send: @MainActor @Sendable (Action,  Transaction?) -> Void

    public init(send: @escaping @MainActor @Sendable (Action, Transaction?) -> Void) {
        self.send = send
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    public func callAsFunction(_ action: Action) {
        guard !Task.isCancelled else { return }
        self.send(action, nil)
    }

    /// Sends an action back into the system from an effect with transaction.
    ///
    /// - Parameters:
    ///  - action: An action.
    ///  - transaction: A transaction.
    public func callAsFunction(_ action: Action, transaction: Transaction) {
        guard !Task.isCancelled else { return }
        self(action, transaction: transaction)
    }
}

/// Represents the potential side effects that can be produced by a reducer in response to an action.
///
/// - `none`: No side effect will be executed.
/// - `run`: An asynchronous operation that can dispatch additional actions.
/// - `cancel`: Cancels any currently running side effect associated with the reducer.
enum Effect<Action, NavigationAction> {

    /// No side effect; the action only updates the state without triggering further behavior.
    case none

    /// An asynchronous operation that can dispatch follow-up actions back to the presenter.
    ///
    /// - Parameter send: A closure to dispatch additional actions to the presenter during or after the operation.
    case run((_ send: Send<Action>, _ sendNavigation: @escaping SendNavigation<NavigationAction>) async -> Void, cancelId: String? = nil)

    /// Cancels the currently running effect, if any.
    ///
    /// This is useful to ensure that long-running or obsolete effects don't continue consuming resources
    /// or triggering unwanted updates.
    case cancel(cancelId: String)
}
