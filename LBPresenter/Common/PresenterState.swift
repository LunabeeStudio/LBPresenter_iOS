//
//  PresenterState.swift
//  DansMaPoche
//
//  Created by Rémi Lanteri on 25/11/2024.
//

protocol Actionnable {
    /// The type of actions that can be handled by the presenter.
    ///
    /// Actions represent events, user interactions, or commands that trigger
    /// changes to the state or produce side effects. Conforming types must ensure
    /// `Action` is `Sendable` to enable safe usage in asynchronous contexts.
    associatedtype Action: Sendable
}

/// A protocol that defines the requirements for a state object used in a `Presenter`,
/// enabling consistent management of UI state and actions.
///
/// Conforming types represent the current state of the application or feature
/// and facilitate the handling of user or system-initiated actions.
protocol PresenterState: Actionnable {
    /// The type that encapsulates the state visible to the UI.
    ///
    /// This state represents what the UI observes and reacts to.
    associatedtype UiState
}
