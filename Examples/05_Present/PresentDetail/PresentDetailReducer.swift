//
//  PresentDetailReducer.swift
//  Examples
//
//  Created by Rémi Lanteri on 07/01/2025.
//

import LBPresenter

struct PresentDetailReducer {
    @MainActor static let reducer: Reducer<PresentDetailState, Never> = .init(reduce: { state, action in
        switch action {
        case .dismiss:
            switch state.uiState {
            case .noData:
                return .none
            case .data:
                return .dismiss(all: false)
            }
        case .dismissAll:
            switch state.uiState {
            case .noData:
                return .none
            case .data:
                return .dismiss(all: true)
            }
        case let .present(model):
            state.presented = model
            return .none
        }
    })
}
