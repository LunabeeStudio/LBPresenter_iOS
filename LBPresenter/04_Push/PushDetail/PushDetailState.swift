//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushDetailState: PresenterState {

    enum UiState: Equatable {
        case idle, data(modelId : String)
    }

    enum Action: Sendable {
        case back, setup(modelId: String, back: @Sendable () -> Void)
    }

    var uiState: UiState
    var back: (() -> Void)? = nil

    static func == (lhs: PushDetailState, rhs: PushDetailState) -> Bool {
        return lhs.uiState == rhs.uiState
    }

    init() {
        self.uiState = .idle
    }
}
