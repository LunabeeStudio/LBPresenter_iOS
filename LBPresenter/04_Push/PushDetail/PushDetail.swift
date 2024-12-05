//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetail: View {

    @StateObject private var presenter: LBPresenter<PushDetailState> = .init(initialState: .init(), reducer: PushDetailReducer.reducer)

    let model: PushDetailModel
    let back: @Sendable () -> Void


    var body: some View {
        let _ = Self._printChanges()
        content
            .task {
                presenter.send(.setup(modelId: model.id, back: back))
            }
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.uiState {
        case let .data(modelId):
            List {
                VStack {
                    Text(modelId)
                    Button {
                        presenter.send(.back)
                    } label: {
                        Text("Back")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        case .idle: EmptyView()
        }
    }
}
