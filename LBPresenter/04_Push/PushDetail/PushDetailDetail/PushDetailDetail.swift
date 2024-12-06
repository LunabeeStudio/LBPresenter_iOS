//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetailDetail: View {

    @StateObject private var presenter: LBPresenter<PushDetailDetailState>

    init(pushDetailDetailState: PushDetailDetailState) {
        self._presenter = StateObject(wrappedValue: .init(initialState: pushDetailDetailState, reducer: PushDetailDetailReducer.reducer))
    }

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Text(presenter.state.uiState.modelId)
                Button {
                    presenter.send(.back)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)
                Button {
                    presenter.send(.backToBack)
                } label: {
                    Text("Back to Back")
                }
                .buttonStyle(.bordered)
                Button {
                    presenter.send(.closeFlow)
                } label: {
                    Text("Close flow")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
