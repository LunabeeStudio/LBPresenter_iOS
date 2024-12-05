//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import Foundation
import Combine

struct PublishedReducer {
    @MainActor static var cancellables: Set<AnyCancellable> = []

    static let reducer: LBPresenter<PublishedState>.Reducer = { state, action in
        switch action {
        case .startTimer:
            return (state.update(\.uiState, with: .loading), .run { send in
                await TimerDataSource.shared.startTimer()
                send(.showData)
            })
        case .stopTimer:
            return (state, .run { send in
                TimerDataSource.shared.stopTimer()
                send(.showData)
            })
        case .showData:
            return (state.update(\.uiState, with: .data(timer: nil)), .none)
        case let .timerDidUpdate(date):
            return (state.update(\.uiState, with: .data(timer: date)), .none)
        case .startObserve:
            return (state, .run { @MainActor send in
                TimerDataSource.shared.observeTimer()
                    .sink {
                        print("update")
                        send(.timerDidUpdate($0))
                    }
                    .store(in: &cancellables)
            })
        case .stopObserve:
            cancellables.removeAll()
            return (state, .none)
        }
    }
}
