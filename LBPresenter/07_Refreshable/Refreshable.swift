//
//  ContentView.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Refreshable: View {
    @StateObject private var presenter: LBPresenter<RefreshableState> = .init(initialState: .init(uiState: .data), reducer: RefreshableReducer.reducer)

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
        .refreshable {
            await presenter.send(.refreshData)
        }
    }
}

#Preview {
    Refreshable()
}
