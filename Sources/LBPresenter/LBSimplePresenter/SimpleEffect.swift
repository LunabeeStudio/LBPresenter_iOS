//
//  SimpleEffect.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 10/04/2025.
//

import SwiftUI

public enum SimpleEffect<Action> {

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
        @MainActor (_ send: Send<Action>) async -> Void,
        cancelId: String? = nil
    )

    /// Cancels an ongoing side effect associated with a specific `cancelId`.
    ///
    /// This effect is used to terminate long-running or obsolete tasks, ensuring they do not
    /// consume unnecessary resources or produce outdated updates.
    ///
    /// - Parameter cancelId: The identifier of the effect to be canceled.
    case cancel(cancelId: String)
}
