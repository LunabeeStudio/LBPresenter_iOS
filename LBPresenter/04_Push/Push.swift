//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Push: View {
    @StateObject private var presenter: LBPresenter<PushState> = .init(initialState: .init(uiState: .init(isLoading: false)), reducer: PushReducer.reducer)
    @StateObject private var flow: LBPresenter<PushFlowState> = .init(initialState: .init(), reducer: PushFlowReducer.reducer)

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let _ = Self._printChanges()
        NavigationStack(path: flow.binding(for: flow.state.path, send: PushFlowState.Action.navigate)) {
            List {
                VStack {
                    Button {
                        flow.send(.navigate(.detail(.init(id: "pushed"))))
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
                    PushDetail(pushDetailState: .init(modelId: model.id))
                        .environmentObject(flow)
                }

            }
        }
    }
}

#Preview {
    Push()
}
