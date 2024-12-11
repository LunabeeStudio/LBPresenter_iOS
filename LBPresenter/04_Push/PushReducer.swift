//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushReducer {
    static let reducer: LBPresenter<PushState, PushFlowState>.Reducer = { state, action in
        switch action {
        case .removeLoading:
            state.uiState.isLoading = false
            return .run { _, send in
                send(.navigate(.detail(PushDetailModel(id: "pushed with delay"))))
            }
        case let .delayNavigate(model):
            state.uiState.isLoading = true
            return .run { send, _ in
                try? await Task.sleep(for: .seconds(2))
                send(.removeLoading)
            }
        }
    }

    static let navReducer: LBPresenter<PushState, PushFlowState>.NavReducer = { state, action in
        switch action {
        case let .navigate(model):
            if let model {
                state.path.append(model)
            } else {
                state.path.removeLast()
            }
        case .pop:
            state.path.removeLast()
        case .popToRoot:
            state.path.removeAll()
        }
    }
}
