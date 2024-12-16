//
//  View+Task.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import SwiftUI

// Extension to the View protocol to add custom task and refreshable modifiers.
extension View {

    /// Attaches an asynchronous task to the view that sends an action to the presenter when the view appears.
    ///
    /// This modifier integrates with an `LBPresenter` to trigger an action asynchronously
    /// when the view appears. It is a customized version of SwiftUI's `.task` modifier,
    /// tailored for managing actions in a presenter-driven architecture.
    ///
    /// - Parameters:
    ///   - presenter: An instance of `LBPresenter` responsible for managing the state and handling actions.
    ///   - action: An action of type `State.Action` to be sent to the presenter when the task is triggered.
    /// - Returns: A modified view with the asynchronous task behavior attached.
    ///
    /// - Note:
    ///   - The task is executed when the view appears or is re-rendered due to state changes.
    ///   - This modifier ensures better integration with the presenter's action-handling mechanism.
    public func task<State: PresenterState, NavState: Actionnable>(
        _ presenter: LBPresenter<State, NavState>,
        action: State.Action
    ) -> some View where State.Action: Sendable {
        // Use the `.task` modifier to execute the specified asynchronous action when the view appears.
        self.task {
            await presenter.send(action) // Send the provided action to the presenter asynchronously.
        }
    }
}
