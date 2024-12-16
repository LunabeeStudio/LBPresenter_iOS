//
//  View+Refreshable.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import SwiftUI

// Extension to the View protocol to add custom task and refreshable modifiers
extension View {

    /// Adds a pull-to-refresh interaction to the view that sends an action to the presenter.
    ///
    /// This modifier is triggered when the user performs a "pull-to-refresh" gesture.
    /// It's a specialized version of the `.refreshable` modifier, tailored for use with an `LBPresenter`.
    ///
    /// - Parameters:
    ///   - presenter: The `LBPresenter` responsible for managing the state and sending actions.
    ///   - action: The action of type `State.Action` to send to the presenter when the refresh is triggered.
    /// - Returns: A view with the refreshable behavior attached.
    public func refreshable<State: PresenterState, NavState: Actionnable>(_ presenter: LBPresenter<State, NavState>, action: State.Action) -> some View where State.Action: Sendable {
        // The `.refreshable` modifier handles the pull-to-refresh gesture and executes asynchronous code.
        self.refreshable {
            await presenter.send(action)
        }
    }
}
