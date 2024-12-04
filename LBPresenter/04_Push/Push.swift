//
//  ContentView.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Push: View {
    @StateObject private var presenter: LBPresenter<PushState> = .init(initialState: .init(uiState: .init()), reducer: PushReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            List {
                VStack {
                    Button {
                        presenter.send(.navigate(PushDetailModel(id: "pushed")))
                    } label: {
                        Text("push detail")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationDestination(item: presenter.binding(for: presenter.state.navigationScope, send: PushState.Action.navigate)) { model in
                PushDetail(model: model)
            }
        } detail: {
            PushDetail(model: nil)
        }
    }
}

#Preview {
    Push()
}
