//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushDetailState: PresenterState {
    struct UiState: Equatable {
        var modelId : String?
    }

    enum Action: Sendable {
        case setInitialState(modelId: String?)
    }

    var uiState: UiState

    init(modelId: String? = nil) {
        self.uiState = .init(modelId: modelId)
    }
}
