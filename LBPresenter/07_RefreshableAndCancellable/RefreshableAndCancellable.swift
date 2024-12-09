//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct RefreshableAndCancellable: View {
    @StateObject private var presenter: LBPresenter<RefreshableAndCancellableState> = .init(initialState: .init(uiState: .data), reducer: RefreshableAndCancellableReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        List {
            VStack {
                Button {
                    presenter.send(.cancel)
                } label: {
                    Text("cancel")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .refreshable(presenter, action: .refreshData)
    }
}

#Preview {
    RefreshableAndCancellable()
}
