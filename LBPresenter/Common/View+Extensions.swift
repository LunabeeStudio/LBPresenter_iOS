//
//  View+Extensions.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import SwiftUI

extension View {
    func task<State: PresenterState>(
        _ presenter: LBPresenter<State>,
        action: State.Action) -> some View where State.Action: Sendable {
        self.task {
            await presenter.send(action)
        }
    }

    func refreshable<State: PresenterState>(
        _ presenter: LBPresenter<State>,
        action: State.Action) -> some View where State.Action: Sendable {
        self.refreshable {
            await presenter.send(action)
        }
    }
}
