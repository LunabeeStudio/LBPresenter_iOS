//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushDetailDetailState: PresenterState {

    struct UiState: Equatable {
        var modelId : String
    }

    enum Action: Sendable {
        case back, backToBack, closeFlow
    }

    var uiState: UiState
    var back: (() -> Void)
    var backToBack: (() -> Void)
    var closeFlow: (() -> Void)

    init(modelId: String, back: @escaping () -> Void, backToBack: @escaping () -> Void, closeFlow: @escaping () -> Void) {
        self.uiState = .init(modelId: modelId)
        self.back = back
        self.backToBack = backToBack
        self.closeFlow = closeFlow
    }
}
