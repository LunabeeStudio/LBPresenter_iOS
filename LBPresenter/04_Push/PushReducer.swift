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
            return (state.update(\.navigationScope, with: nil), .none)
        case let .navigate(model):
            return (state.update(\.navigationScope, with: model), .run({ send in
                send(.removeLoading)
            }))
        case .removeLoading:
            return (state.update(\.uiState.isLoading, with: false), .none)
        case let .delayNavigate(model):
            return (state.update(\.uiState.isLoading, with: true), .run({ send in
                try? await Task.sleep(for: .seconds(3))
                send(.navigate(model))
            }))
        }
    }
}
