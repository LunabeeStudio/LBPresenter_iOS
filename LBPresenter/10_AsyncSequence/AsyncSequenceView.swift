//
//  AsyncSequenceView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import SwiftUI

struct AsyncSequenceView: View {
    @StateObject private var presenter: LBPresenter<AsyncSequenceState> = .init(initialState: .init(state: .loading), initialActions: [.startEmitter], reducer: AsyncSequenceReducer.reducer)

    var body: some View {
        content
            .task(presenter, action: .startObserve)
    }

    @ViewBuilder
    var content: some View {
        let _ = Self._printChanges()
        switch presenter.state.state {
        case .loading:
            Text("Loading...")
            ProgressView()
                .progressViewStyle(.circular)
        case let .data(date):
            List {
                Text(date, format: .dateTime.hour().minute().second(.twoDigits))
            }
        }
    }
}

#Preview {
    AsyncSequenceView()
}
