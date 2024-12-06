//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct RefreshableAndCancellableReducer {

    private enum CancelID { case refreshable }

    static let reducer: LBPresenter<RefreshableAndCancellableState>.Reducer = { state, action in
        switch action {
        case .refreshData:
            return .run({ send in
                do {
                    try await Task.sleep(for: .seconds(3))
                } catch is CancellationError {
                    print("Task was cancelled")
                } catch {
                    print("ooops! \(error)")
                }
            }, cancelId: CancelID.refreshable)
        case .cancel:
            return .cancel(cancelId: CancelID.refreshable)
        }
    }
}
