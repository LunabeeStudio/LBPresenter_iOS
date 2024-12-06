//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PresentReducer {
    static let reducer: LBPresenter<PresentState>.Reducer = { state, action in
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
    }
}
