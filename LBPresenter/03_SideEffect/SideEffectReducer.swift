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
            return (state.update(\.uiState, with: .loading), .run { send in
                try? await Task.sleep(for: .seconds(1))
                send(.showData)
            })
        case .showLoadingThenError:
            return (state.update(\.uiState, with: .loading), .run { send in
                try? await Task.sleep(for: .seconds(1))
                send(.showError)
            })
        case .showData:
            return (state.update(\.uiState, with: .data), .none)
        case .showError:
            return (state.update(\.uiState, with: .error), .none)
        }
    }
}
