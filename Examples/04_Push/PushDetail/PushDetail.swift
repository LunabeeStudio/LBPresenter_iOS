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
                    presenter.send(.back)
                } label: {
                    Text("Back")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
