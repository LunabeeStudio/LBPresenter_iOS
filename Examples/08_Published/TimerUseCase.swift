//
//  TimerUseCase.swift
//  LBPresenter
//
//  Created by Q2 on 05/12/2024.
//

import Combine
import Foundation

class TimerDataSource {
    nonisolated(unsafe) static let shared: TimerDataSource = .init()

    private let publisherSubject: PassthroughSubject<Date, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []

    func startTimer() async {
        guard cancellables.isEmpty else { return }
        try? await Task.sleep(for: .seconds(3))

        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] in
                self?.publisherSubject.send($0)
            }
            .store(in: &cancellables)
    }

    func stopTimer() {
        cancellables.removeAll()
    }

    func observeTimer() -> AnyPublisher<Date, Never> {
        publisherSubject
            .eraseToAnyPublisher()
    }
}
