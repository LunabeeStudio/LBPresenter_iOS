//
//  Effect.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import SwiftUI

/// Represents the possible side effects produced by a reducer in response to an action.
///
/// Side effects encapsulate asynchronous operations or external behaviors that occur
/// as a result of an action being handled by the reducer.
///
/// - `none`: Indicates no side effect is produced. The action only updates the state.
/// - `run`: Represents an asynchronous operation that can dispatch additional actions.
/// - `cancel`: Cancels an ongoing effect associated with a specific `cancelId`.
public enum Effect<Action, NavigationAction> {

    /// No side effect; the action only updates the state without triggering additional behavior.
    ///
    /// Use this case when the reducer's response to an action is purely state-driven and does not
    /// require external operations or follow-up actions.
    case none

    /// An asynchronous operation that can dispatch additional actions to the presenter.
    ///
    /// This effect is used to handle operations such as API calls, animations, or other asynchronous tasks.
    /// During or after the operation, actions can be dispatched to update state or trigger navigation.
    ///
    /// - Parameters:
    ///   - send: A closure that allows dispatching additional `Action` instances back to the presenter.
    ///   - sendNavigation: A closure that allows dispatching additional `NavigationAction` instances.
    ///   - cancelId: An optional identifier to associate the effect with a cancelable task.
    case run(
        @MainActor (_ send: Send<Action>, _ sendNavigation: Send<NavigationAction>) async -> Void,
        cancelId: String? = nil
    )

    case dismiss(all: Bool)

    /// Cancels an ongoing side effect associated with a specific `cancelId`.
    ///
    /// This effect is used to terminate long-running or obsolete tasks, ensuring they do not
    /// consume unnecessary resources or produce outdated updates.
    ///
    /// - Parameter cancelId: The identifier of the effect to be canceled.
    case cancel(cancelId: String)
}
