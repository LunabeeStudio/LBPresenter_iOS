//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetail: View {
    @StateObject private var presenter: LBPresenter<PushDetailState>
    @EnvironmentObject private var flow: LBPresenter<PushFlowState>

    init(pushDetailState: PushDetailState) {
        self._presenter = 
    }

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Text(presenter.state.uiState.modelId)
                Button {
                    flow.send(.pop)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)

                Button {
                    flow.send(.navigate(.detail(.init(id: "mi-push mi-scorpion et re mi-push derrière"))))
                } label: {
                    Text("push")
                }
                .buttonStyle(.bordered)

                Button {
                    flow.send(.popToRoot)
                } label: {
                    Text("popToRoot")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
