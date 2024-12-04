//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct SimpleReducer {
    static let reducer: LBPresenter<SimpleState>.Reducer = { state, action in
        (state, .none)
    }
}
