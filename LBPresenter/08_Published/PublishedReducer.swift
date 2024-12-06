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
            state.uiState = .loading
            return .run { send in
                await TimerDataSource.shared.startTimer()
                send(.showData)
            }
        case .stopTimer:
            return .run { send in
                TimerDataSource.shared.stopTimer()
                send(.showData)
            }
        case .showData:
            state.uiState = .data(timer: nil)
            return .none
        case let .timerDidUpdate(date):
            state.uiState = .data(timer: date)
            return .none
        case .startObserve:
            return .run { @MainActor send in
                TimerDataSource.shared.observeTimer()
                    .sink {
                        print("update")
                        send(.timerDidUpdate($0))
                    }
                    .store(in: &cancellables)
            }
        case .stopObserve:
            cancellables.removeAll()
            return .none
        }
    }
}
