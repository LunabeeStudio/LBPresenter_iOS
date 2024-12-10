//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetail: View {
    @StateObject private var presenter: LBPresenter<PushDetailState, Never>
    @Environment(\.navigationContext) private var context

    init(pushDetailState: PushDetailState) {
        self._presenter = StateObject(wrappedValue: .init(initialState: pushDetailState, reducer: PushDetailReducer.reducer))
    }

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Text(presenter.state.uiState.modelId)
                Button {
                    context?.send(PushFlowState.Action.pop)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)

                Button {
                    context?.send(PushFlowState.Action.navigate(.detail(.init(id: "mi-push mi-scorpion et re mi-push derrière"))))
                } label: {
                    Text("push")
                }
                .buttonStyle(.bordered)

                Button {
                    context?.send(PushFlowState.Action.popToRoot)
                } label: {
                    Text("popToRoot")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
