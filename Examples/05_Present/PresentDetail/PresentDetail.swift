//
//  Detail.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

struct PresentDetailModel: Identifiable, Hashable {
    let id: String
}

struct PresentDetail: View {
    @ObservedObject var presenter: LBPresenter<PresentDetailState, Never>
    
    var body: some View {
        contentView
            .sheet(item: presenter.binding(for: presenter.state.presented, send: PresentDetailState.Action.present)) { model in
                PresentDetail(presenter: presenter.getPresentedChild(for: .init(uiState: .data(model)), reducer: PresentDetailReducer.reducer))
            }
    }

    @ViewBuilder
    private var contentView: some View {
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

            Button {
                presenter.send(.present(PresentDetailModel(id: "presented twice")))
            } label: {
                Text("Present another")
            }
            .buttonStyle(.bordered)

            Button {
                presenter.send(.dismissAll)
            } label: {
                Text("dismiss all")
            }
            .buttonStyle(.bordered)
        }
    }
}
