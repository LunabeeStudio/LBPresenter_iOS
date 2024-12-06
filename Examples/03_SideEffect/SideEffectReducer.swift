//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct SideEffectReducer {
    static let reducer: LBPresenter<SideEffectState>.Reducer = { state, action in
        switch action {
        case .showLoadingThenData:
            state.uiState = .loading
            return .run { send in
                try? await Task.sleep(for: .seconds(1))
                send(.showData)
            }
        case .showLoadingThenError:
            state.uiState = .loading
            return .run { send in
                try? await Task.sleep(for: .seconds(1))
                send(.showError)
            }
        case .showData:
            state.uiState = .data
            return .none
        case .showError:
            state.uiState = .error
            return .none
        }
    }
}
