//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushDetailReducer {
    static let reducer: LBPresenter<PushDetailState, Never>.Reducer = { state, action in
        switch action {
        case let .setInitialState(modelId: id):
            state.uiState.modelId = id
            return .none
        }
    }
}
