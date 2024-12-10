//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Action: View {
    @StateObject private var presenter: LBPresenter<ActionState, Never> = .init(initialState: .init(uiState: .init(count: 0)), reducer: ActionReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        List {
            Text("Count = \(presenter.state.uiState.count)")
            Button("Increment") { presenter.send(.increment) }
            Button("Decrement") { presenter.send(.decrement) }
        }
    }
}

#Preview {
    Action()
}
