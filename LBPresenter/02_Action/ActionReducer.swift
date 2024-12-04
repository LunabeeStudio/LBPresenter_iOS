//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct ActionReducer {
    static let reducer: LBPresenter<ActionState>.Reducer = { state, action in
        switch action {
        case .increment:
            return (state.update(\.uiState.count, with: state.uiState.count + 1), .none)
        case .decrement:
            return (state.update(\.uiState.count, with: state.uiState.count - 1), .none)
        }
    }
}
