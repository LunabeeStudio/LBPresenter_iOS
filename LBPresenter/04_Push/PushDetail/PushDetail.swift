//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetail: View {
    @ObservedObject private var presenter: LBPresenter<PushDetailState, PushFlowState>

    init(presenter: LBPresenter<PushDetailState, PushFlowState>) {
        self.presenter = presenter
    }

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Text(presenter.state.uiState.modelId ?? "")
                Button {
                    presenter.send(.pop)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)

                Button {
                    presenter.send(.navigate(.detail(.init(id: "mi-push mi-scorpion et re mi-push derrière"))))
                } label: {
                    Text("push")
                }
                .buttonStyle(.bordered)

                Button {
                    presenter.send(.popToRoot)
                } label: {
                    Text("popToRoot")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
