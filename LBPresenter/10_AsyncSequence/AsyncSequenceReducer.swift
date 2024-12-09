//
//  AsyncSequenceReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation

struct AsyncSequenceReducer {
    static let reducer: LBPresenter<AsyncSequenceState>.Reducer = { state, action in
        switch action {
        case .startEmitter:
            return .run { send in
                TimerEmitter.shared.startTimer()
            }
        case .startObserve:
            return .run { send in
                for await second in TimerEmitter.shared.sequence() {
                    send(.didReceiveData(.now), .init(animation: .smooth))
                }
            }
        case let .didReceiveData(date):
            state.state = .data(date)
            return .none
        }
    }
}
