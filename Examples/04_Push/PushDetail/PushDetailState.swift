//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct PushDetailState: PresenterState {
    enum UiState: Equatable {
        case idle, data(String)
    }

    enum Action: Sendable {
        case back, backToRoot, pushDetail, moveToData, setData
    }

    var uiState: UiState = .idle
    var modelId: String

    init(modelId: String) {
        self.modelId = modelId
    }
}
