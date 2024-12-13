//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Push: View {
    @StateObject private var presenter: LBPresenter<PushState, PushFlowState> = .init(initialState: .init(uiState: .init(isLoading: false)), reducer: PushReducer.reducer, navState: .init(), navReducer: PushReducer.navReducer)

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let _ = Self._printChanges()
        NavigationStack(path: presenter.bindPath(send: PushFlowState.Action.navigate)) {
            List {
                VStack {
                    Button {
                        presenter.send(.pushDetail)
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                    }

                }
            }
            .navigationDestination(for: PushFlowState.Destination.self) { destination in
                switch destination {
                case let .detail(model):
                    PushDetail(presenter: presenter.getChild(for: .init(modelId: model.id), and: PushDetailReducer.reducer))
                }
            }
        }
    }
}

#Preview {
    Push()
}
