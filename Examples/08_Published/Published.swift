//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PublishedDemo: View {
    @StateObject private var presenter: LBPresenter<PublishedState> = .init(initialState: .init(uiState: .loading), initialActions: [.startTimer], reducer: PublishedReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        content
            .onAppear { presenter.send(.startObserve) }
            .onDisappear { presenter.send(.stopObserve) }
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.uiState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case let .data(timer):
            List {
                if let timer {
                    Text("Timer = \(timer)")
                } else {
                    Text("Waiting for timer...")
                }
                Button {
                    presenter.send(.stopTimer)
                } label: {
                    Text("Stop Timer")
                }
                .buttonStyle(.bordered)
                .disabled(timer == nil)
            }
        }
    }
}

#Preview {
    PublishedDemo()
}
