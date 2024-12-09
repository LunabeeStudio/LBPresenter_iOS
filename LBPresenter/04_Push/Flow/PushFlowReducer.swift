//
//  PushFlowReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

struct PushFlowReducer {
    static let reducer: LBPresenter<PushFlowState>.Reducer = { state, action in
        switch action {
        case let .navigate(model):
            state.path.append(model)
        case .pop:
            state.path.removeLast()
        case .popToRoot:
            state.path.removeAll()
        }
        return .none
    }
}
