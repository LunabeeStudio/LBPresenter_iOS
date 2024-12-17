//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct ActionReducer {
    @MainActor static let reducer: Reducer<ActionState, Never> = .init(reduce: { state, action, _ in
        switch action {
        case .increment:
            state.uiState.count += 1
            return .none
        case .decrement:
            state.uiState.count -= 1
            return .none
        }
    })
}
