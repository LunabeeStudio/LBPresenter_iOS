//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushDetailState: PresenterState {
    enum UiState {
        case ready(modelId: String?, PushDetailState.Action.Type)
    }

    enum Action: Actionning {
        case back, backToRoot, pushDetail
    }

    var uiState: UiState

    init(modelId: String) {
        self.uiState = .ready(modelId: modelId, Action.self)
    }
}
