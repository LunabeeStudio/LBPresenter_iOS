//
//  AsyncSequenceReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation
import LBPresenter

struct AsyncSequenceReducer {
    @MainActor static let reducer: Reducer<AsyncSequenceState, Never> = .init(reduce: { state, action in
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
    })
}
