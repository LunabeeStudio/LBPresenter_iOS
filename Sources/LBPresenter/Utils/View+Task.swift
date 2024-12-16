//
//  View+Task.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import SwiftUI

// Extension to the View protocol to add custom task and refreshable modifiers
extension View {
    /// Attaches an asynchronous task to the view that sends an action to the presenter.
    ///
    /// This task is triggered when the view appears. It's a specialized version of the `.task` modifier,
    /// designed for use with an `LBPresenter` that manages state and navigation actions.
    ///
    /// - Parameters:
    ///   - presenter: The `LBPresenter` responsible for managing the state and sending actions.
    ///   - action: The action of type `State.Action` to send to the presenter when the task executes.
    /// - Returns: A view with the task attached.
    public func task<State: PresenterState, NavState: Actionnable>(_ presenter: LBPresenter<State, NavState>, action: State.Action) -> some View where State.Action: Sendable {
        // The `.task` modifier allows asynchronous code to run when the view appears.
        self.task {
            await presenter.send(action)
        }
    }
}
