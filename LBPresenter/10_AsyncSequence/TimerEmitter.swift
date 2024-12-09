//
//  TimerEmitter.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation

class TimerEmitter {
    nonisolated(unsafe) static let shared: TimerEmitter = .init()
    private var timerSequence: AsyncTimerSequence?

    func startTimer() {
        timerSequence = .init(interval: .seconds(1))
    }

    func sequence() -> AsyncTimerSequence {
        timerSequence!
    }

    func stopTimer() {
        timerSequence = nil
    }

    struct AsyncTimerSequence: AsyncSequence {
        struct Iterator: AsyncIteratorProtocol {
            var clock: ContinuousClock?
            let interval: ContinuousClock.Instant.Duration
            var last: ContinuousClock.Instant?

            init(interval: ContinuousClock.Instant.Duration, clock: ContinuousClock) {
                self.clock = clock
                self.interval = interval
            }

            public mutating func next() async -> ContinuousClock.Instant? {
                guard let clock = self.clock else {
                    return nil
                }

                let next = (self.last ?? clock.now).advanced(by: self.interval)
                do {
                    try await clock.sleep(until: next)
                } catch {
                    self.clock = nil
                    return nil
                }
                let now = clock.now
                self.last = next
                return now
            }
        }

        let clock: ContinuousClock = .init()
        let interval: ContinuousClock.Instant.Duration

        /// Create an `AsyncTimerSequence` with a given repeating interval.
        init(interval: ContinuousClock.Instant.Duration) {
            self.interval = interval
        }

        func makeAsyncIterator() -> Iterator {
            Iterator(interval: interval, clock: clock)
        }
    }
}
