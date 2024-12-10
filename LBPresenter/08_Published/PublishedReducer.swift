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

    static let reducer: LBPresenter<PublishedState, Never>.Reducer = { state, action in
        switch action {
        case .startTimer:
            state.uiState = .loading
            return .run { send, _ in
                await TimerDataSource.shared.startTimer()
                send(.showData, .init(animation: .easeInOut))
            }
        case .stopTimer:
            return .run { send, _ in
                TimerDataSource.shared.stopTimer()
                send(.showData, .init(animation: .easeInOut))
            }
        case .showData:
            state.uiState = .data(timer: nil)
            return .none
        case let .timerDidUpdate(date):
            state.uiState = .data(timer: date)
            return .none
        case .startObserve:
            return .run { @MainActor send, _ in
                TimerDataSource.shared.observeTimer()
                    .sink {
                        print("update")
                        send(.timerDidUpdate($0), nil)
                    }
                    .store(in: &cancellables)
            }
        case .stopObserve:
            cancellables.removeAll()
            return .none
        }
    }
}
