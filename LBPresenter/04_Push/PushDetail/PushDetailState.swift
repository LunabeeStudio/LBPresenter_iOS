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
        var modelId : String
    }

    enum Action: Sendable {
        case back
    }

    var uiState: UiState
    var back: (() -> Void)

    init(modelId: String, back: @escaping () -> Void) {
        self.uiState = .init(modelId: modelId)
        self.back = back
    }
}
