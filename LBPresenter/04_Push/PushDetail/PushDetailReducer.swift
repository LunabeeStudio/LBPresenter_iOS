//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushDetailReducer {
    static let reducer: LBPresenter<PushDetailState>.Reducer = { state, action in
        switch action {
        case .back, .closeFlow:
            state.back()
            return .none
        case .navigate(nil), .pop:
            state.navigationScope = nil
            return .none
        case let .navigate(model):
            state.navigationScope = model
            return .none
        case .popToParent:
            state.navigationScope = nil
            return .run({ send in
                send(.back)
            })
        }
    }
}
