//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PresentReducer {
    @MainActor static let reducer: Reducer<PresentState, Never> = .init(reduce: { state, action, _ in
        switch action {
        case .present(nil):
            switch state.uiState {
            case .data:
                state.uiState = .data(nil)
                return .none
            }
        case let .present(model):
            switch state.uiState {
            case .data:
                state.uiState = .data(model)
                return .none
            }
        }
    })
}
