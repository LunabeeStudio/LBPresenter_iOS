//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct NavigationSplitReducer {
    static let reducer: LBPresenter<NavigationSplitState>.Reducer = { state, action in
        switch action {
        case .fetchData:
            return (state, .run { send in
                try? await Task.sleep(for: .seconds(3))
                send(.gotData(nil))
            })
        case let .gotData(presentation):
            return (state.update(\.uiState, with: .data(presentation)), .none)
        case .navigate(nil):
            return (state.update(\.navigationScope, with: nil), .none)
        case let .navigate(model):
            return (state.update(\.navigationScope, with: model), .cancel)
        case .present(nil):
            switch state.uiState {
            case .data:
                return (state.update(\.uiState, with: .data(nil)), .none)
            default:
                return (state, .none)
            }
        case let .present(model):
            switch state.uiState {
            case .data:
                return (state.update(\.uiState, with: .data(model)), .cancel)
            default:
                return (state, .none)
            }
        }
    }
}
