//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushReducer {
    static let reducer: LBPresenter<PushState>.Reducer = { state, action in
        switch action {
        case .navigate(nil), .pop:
            state.navigationScope = nil
            return .none
        case let .navigate(model):
            state.navigationScope = model
            return .run({ send in
                send(.removeLoading)
            })
        case .removeLoading:
            state.uiState.isLoading = false
            return .none
        case let .delayNavigate(model):
            state.uiState.isLoading = true
            return .run({ send in
                try? await Task.sleep(for: .seconds(3))
                send(.navigate(model))
            })
        }
    }
}
