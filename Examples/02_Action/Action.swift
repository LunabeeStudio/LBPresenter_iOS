//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  This screen demonstrates how actions are sent to mutate the state using a presenter.
  
  Key Features:
  - A `count` value is managed in the state and displayed in the UI.
  - Two buttons allow the user to increment or decrement the `count`.
  - State changes are handled by the `LBPresenter` via the `ActionReducer`.
  
  This example illustrates the core concept of connecting user actions to state updates in a SwiftUI view.
  """

struct Action: View {

    @StateObject private var presenter: LBPresenter<ActionState, Never> = .init(initialState: .init(), reducer: ActionReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        Form {
            AboutView(readMe: readMe)
            Text("Count = \(presenter.state.uiState.count)")
            Button("Increment") { presenter.send(.increment) }
            Button("Decrement") { presenter.send(.decrement) }
        }
    }
}

#Preview {
    Action()
}
