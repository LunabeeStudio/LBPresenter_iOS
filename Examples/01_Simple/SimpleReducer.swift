//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct SimpleReducer {
    @MainActor static let reducer: Reducer<SimpleState, Never> = .init(reduce: { state, action in
        .none
    })
}
