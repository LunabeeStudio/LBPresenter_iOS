//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

struct PushDetail: View {
    @ObservedObject var presenter: LBPresenter<PushDetailState, PushFlowState>

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                switch presenter.state.uiState {
                case .idle:
                    ProgressView()
                case .data(let string):
                    Text(string)
                }
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
        .task(presenter, action: PushDetailState.Action.moveToData)
    }
}
