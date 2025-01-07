//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import LBPresenter

struct RefreshableAndCancellableReducer {

    private enum CancelID: String { case refreshable }

    @MainActor static let reducer: Reducer<RefreshableAndCancellableState, Never> = .init(reduce: { state, action in
        switch action {
        case .refreshData:
            return .run({ send, _ in
                do {
                    print("Task started")
                    try await Task.sleep(for: .seconds(3))
                    print("Task completed")
                } catch is CancellationError {
                    print("Task was cancelled")
                } catch {
                    print("ooops! \(error)")
                }
            }, cancelId: CancelID.refreshable.rawValue)
        case .cancel:
            return .cancel(cancelId: CancelID.refreshable.rawValue)
        }
    })
}
