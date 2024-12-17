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
        switch presenter.state.uiState {
        case let .ready(modelId, actionType):
            List {
                VStack {
                    Text("\(modelId)")
                    Button {
                        presenter.send(actionType.back)
                    } label: {
                        Text("Back")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        presenter.send(actionType.pushDetail)
                    } label: {
                        Text("push")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        presenter.send(actionType.backToRoot)
                    } label: {
                        Text("popToRoot")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
    }
}
