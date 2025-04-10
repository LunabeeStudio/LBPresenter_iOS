//
//  View+Refreshable.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import SwiftUI

// Extension to the View protocol to add custom task and refreshable modifiers.
extension View {

    /// Adds a pull-to-refresh interaction to the view, triggering an action in the presenter.
    ///
    /// This modifier enables pull-to-refresh functionality and is designed for integration with an `LBPresenter`.
    /// When the user performs a pull-to-refresh gesture, the specified action is sent asynchronously to the presenter.
    ///
    /// - Parameters:
    ///   - presenter: An instance of `LBPresenter` responsible for managing state and handling actions.
    ///   - action: An action of type `State.Action` to be sent to the presenter when the refresh is triggered.
    /// - Returns: A modified view with pull-to-refresh functionality.
    ///
    /// - Note:
    ///   - This is a specialized wrapper around SwiftUI's `.refreshable` modifier, tailored for use with `LBPresenter`.
    ///   - The action is sent asynchronously using the `send` method of the presenter.
    public func refreshable<State: PresenterState, NavState: Actionnable>(
        _ presenter: LBPresenter<State, NavState>,
        action: State.Action
    ) -> some View where State.Action: Sendable {
        // The `.refreshable` modifier handles the pull-to-refresh interaction and executes the provided async code.
        self.refreshable {
            await presenter.send(action) // Send the specified action to the presenter asynchronously.
        }
    }
    
    public func refreshable<State: PresenterState>(
        _ presenter: LBSimplePresenter<State>,
        action: State.Action
    ) -> some View where State.Action: Sendable {
        // The `.refreshable` modifier handles the pull-to-refresh interaction and executes the provided async code.
        self.refreshable {
            await presenter.send(action) // Send the specified action to the presenter asynchronously.
        }
    }
}
