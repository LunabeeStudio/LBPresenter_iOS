//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct RefreshableReducer {
    static let reducer: LBPresenter<RefreshableState>.Reducer = { state, action in
        switch action {
        case .refreshData:
            return .run { send in
                try? await Task.sleep(for: .seconds(3))
            }
        case .cancel:
            return .cancel
        }
    }
}
