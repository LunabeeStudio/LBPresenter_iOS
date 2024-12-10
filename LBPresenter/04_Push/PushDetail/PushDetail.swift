//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetail: View {
    @StateObject private var presenter: LBPresenter<PushDetailState, Never>
//    @EnvironmentObject private var flow: LBPresenter<PushFlowState>

    init(pushDetailState: PushDetailState) {
        self._presenter = StateObject(wrappedValue: .init(initialState: pushDetailState, reducer: PushDetailReducer.reducer))
    }

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Text(presenter.state.uiState.modelId)
                Button {
//                    flow.send(.pop)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)

                Button {
//                    flow.send(.navigate(.detail(.init(id: "mi-push mi-scorpion et re mi-push derrière"))))
                } label: {
                    Text("push")
                }
                .buttonStyle(.bordered)

                Button {
//                    flow.send(.popToRoot)
                } label: {
                    Text("popToRoot")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
