//
//  ContentView.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Present: View {
    @StateObject private var presenter: LBPresenter<PresentState> = .init(initialState: .init(uiState: .data( nil)), reducer: PresentReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        content
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.uiState {
        case let .data(presentationScope):
            List {
                VStack {
                    Button {
                        presenter.send(.present(PresentDetailModel(id: "presented")))
                    } label: {
                        Text("present detail")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .sheet(item: presenter.binding(for: presentationScope, send: PresentState.Action.present)) { model in
                PresentDetail(model: model)
            }
        }
    }
}

#Preview {
    Present()
}
