//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushReducer {
    static let reducer: LBPresenter<PushState>.Reducer = { state, action in
        switch action {
        case .navigate(nil):
            return (state.update(\.navigationScope, with: nil), .none)
        case let .navigate(model):
            return (state.update(\.navigationScope, with: model), .none)
        }
    }
}
