//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

struct PresentDetailModel: Identifiable, Equatable, Hashable {
    let id: String
}

struct PresentDetail: View {
    @ObservedObject var presenter: LBPresenter<PresentDetailState, Never>
    
    var body: some View {
        switch presenter.state.uiState {
        case .noData:
            EmptyView()
        case let .data(model):
            Text(model.id)

            Button {
                presenter.send(.dismiss)
            } label: {
                Text("Dismiss")
            }
            .buttonStyle(.bordered)
        }
    }
}
