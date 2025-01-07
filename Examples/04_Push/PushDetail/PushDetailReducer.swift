//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import LBPresenter

struct PushDetailReducer {
    @MainActor static let reducer: Reducer<PushDetailState, PushFlowState> = .init(reduce: { state, action in
        switch action {
        case .back:
            return .run { _, sendNavigation in
                sendNavigation(.pop)
            }
        case .pushDetail:
            return .run { _, sendNavigation in
                sendNavigation(.navigate(.detail(.init(id: "mi-push mi-scorpion et re mi-push derrière"))))
            }
        case .backToRoot:
            return .run { _, sendNavigation in
                sendNavigation(.popToRoot)
            }
        case .moveToData:
            return .run { send, _ in
                try? await Task.sleep(for: .seconds(1))
                send(.setData)
            }
        case .setData:
            state.uiState = .data(state.modelId)
            return .none
        }
    })
}
