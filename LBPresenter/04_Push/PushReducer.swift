//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushReducer {
    @MainActor static let reducer: Reducer<PushState, PushFlowState> = .init(reduce: { state, action in
        switch action {
        case .removeLoading:
            state.uiState.isLoading = false
            return .run { _, send in
                send(.navigate(.detail(PushDetailModel(id: "pushed with delay"))))
            }
        case let .delayNavigate(model):
            state.uiState.isLoading = true
            return .run { send, _ in
                try? await Task.sleep(for: .seconds(2))
                send(.removeLoading)
            }
        }
    })

    @MainActor static let navReducer: NavReducer<PushFlowState> = .init(navReduce: { state, action in
        switch action {
        case let .navigate(model):
            state.navigate(to: model)
        case .pop:
            state.pop()
        case .popToRoot:
            state.popToRoot()
        }
    })
}
