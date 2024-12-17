//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct PushReducer {
    static let reducer: Reducer<PushState, PushFlowState> = .init(reduce: { state, action, sendAction in
        if let action = action as? PushState.ReadyAction {
            switch action {
            case .removeLoading:
                state.uiState = .ready
                return .run { _, send in
                    send(.navigate(.detail(PushDetailModel(id: "pushed with delay"))))
                }
            case .pushDetail:
                return .run { _, send in
                    send(.navigate(.detail(.init(id: "pushed"))))
                }
            case let .delayNavigate(model):
                state.uiState = .loading
                return .run { send, _ in
                    try? await Task.sleep(for: .seconds(2))
                    send(PushState.ReadyAction.removeLoading)
                }
            }
        } else if let action = action as? PushState.LoadingAction {
            switch action {
            case .cancelLoading:
                return .run { send, _ in
                    send(PushState.ReadyAction.removeLoading)
                }
            }
        }
        return .none
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
