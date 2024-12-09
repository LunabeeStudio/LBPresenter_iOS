//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushState: PresenterState, Equatable {
    struct UiState: Equatable {
        var isLoading: Bool
    }

    enum Action: Sendable, Equatable {
        case delayNavigate(PushDetailModel), removeLoading
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
