//
//  PresenterState.swift
//  DansMaPoche
//
//  Created by Rémi Lanteri on 25/11/2024.
//

/// A protocol that defines the requirements for a state object used in a `Presenter`,
/// enabling consistent management of UI state and actions.
///
/// Conforming types represent the current state of the application or feature
/// and facilitate the handling of user or system-initiated actions.
public protocol PresenterState: Actionnable, Equatable {
    /// The type that encapsulates the state visible to the UI.
    ///
    /// This state represents what the UI observes and reacts to.
    associatedtype UiState

    var uiState: UiState { get set }
}

extension PresenterState {
    public func dismiss() {
        fatalError()
    }
}
