//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import LBPresenter

struct PresentReducer {
    @MainActor static let reducer: Reducer<PresentState, Never> = .init(reduce: { state, action in
        switch action {
        case let .present(model):
            switch state.uiState {
            case .data:
                state.presented = model
                return .none
            }
        }
    })
}
