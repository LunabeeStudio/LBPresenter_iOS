//
//  AsyncSequenceReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation

struct AsyncSequenceReducer {
    static let reducer: LBPresenter<AsyncSequenceState, Never>.Reducer = { state, action in
        switch action {
        case .startEmitter:
            return .run { send, _  in
                TimerEmitter.shared.startTimer()
            }
        case .startObserve:
            return .run { send, _ in
                for await second in TimerEmitter.shared.sequence() {
                    send(.didReceiveData(.now), transaction: .init(animation: .smooth))
                }
            }
        case let .didReceiveData(date):
            print("did receive data")
            state.state = .data(date)
            return .none
        }
    }
}
