//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetail: View {

    @StateObject private var presenter: LBPresenter<PushDetailState>

    init(pushDetailState: PushDetailState) {
        self._presenter = StateObject(wrappedValue: .init(initialState: pushDetailState, reducer: PushDetailReducer.reducer))
    }

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Text(presenter.state.uiState.modelId)
                Button {
                    presenter.send(.navigate(.init(id: "Nested Push")))
                } label: {
                    Text("Push Again")
                }
                .buttonStyle(.bordered)
                Button {
                    presenter.send(.back)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationDestination(item: presenter.binding(for: presenter.state.navigationScope, send: PushDetailState.Action.navigate)) { model in
            PushDetailDetail(pushDetailDetailState: .init(
                modelId: model.id,
                back: { presenter.send(PushDetailState.Action.pop) },
                backToBack: { presenter.send(PushDetailState.Action.popToParent) },
                closeFlow: { presenter.send(PushDetailState.Action.closeFlow) }
            ))
        }
    }
}
