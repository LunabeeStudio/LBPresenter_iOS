//
//  Effect.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import SwiftUI

typealias Send<Action> = @Sendable @MainActor (_ action: Action, _ transaction: Transaction?) -> Void

/// Represents the potential side effects that can be produced by a reducer in response to an action.
///
/// - `none`: No side effect will be executed.
/// - `run`: An asynchronous operation that can dispatch additional actions.
/// - `cancel`: Cancels any currently running side effect associated with the reducer.
enum Effect<Action> {

    /// No side effect; the action only updates the state without triggering further behavior.
    case none

    /// An asynchronous operation that can dispatch follow-up actions back to the presenter.
    ///
    /// - Parameter send: A closure to dispatch additional actions to the presenter during or after the operation.
    case run((_ send: @escaping Send<Action>) async -> Void, cancelId: AnyHashable? = nil)

    /// Cancels the currently running effect, if any.
    ///
    /// This is useful to ensure that long-running or obsolete effects don't continue consuming resources
    /// or triggering unwanted updates.
    case cancel(cancelId: AnyHashable)
}
