//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushDetailDetailReducer {
    static let reducer: LBPresenter<PushDetailDetailState>.Reducer = { state, action in
        switch action {
        case .back:
            state.back()
            return .none
        case .backToBack:
            state.backToBack()
            return .none
        case .closeFlow:
            state.closeFlow()
            return .none
        }
    }
}
