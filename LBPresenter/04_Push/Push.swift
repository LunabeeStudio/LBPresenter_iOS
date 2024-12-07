//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Push: View {
    @StateObject private var presenter: LBPresenter<PushState> = .init(initialState: .init(uiState: .init(isLoading: false)), reducer: PushReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Button {
                    presenter.send(.navigate(PushDetailModel(id: "pushed")))
                } label: {
                    Text("push detail")
                }
                .buttonStyle(.bordered)
                Button {
                    presenter.send(.delayNavigate(PushDetailModel(id: "pushed with delay")))
                } label: {
                    Text("push detail with delay")
                }
                .buttonStyle(.bordered)
                if presenter.state.uiState.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .padding()
        }
        .navigationDestination(item: presenter.binding(for: presenter.state.navigationScope, send: PushState.Action.navigate)) { model in
            PushDetail(pushDetailState: .init(modelId: model.id, back: { presenter.send(PushState.Action.pop) }))
        }
    }
}

#Preview {
    Push()
}
