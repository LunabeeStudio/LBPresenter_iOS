//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushDetailReducer {
    static let reducer: LBPresenter<PushDetailState>.Reducer = { state, action in
        switch action {
        case .back:
            state.back()
            return (state, .none)
        }
    }
}
