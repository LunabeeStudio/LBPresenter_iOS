//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

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
                    presenter.send(.back)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)

                Button {
                    presenter.send(.pushDetail)
                } label: {
                    Text("push")
                }
                .buttonStyle(.bordered)

                Button {
                    presenter.send(.backToRoot)
                } label: {
                    Text("popToRoot")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
