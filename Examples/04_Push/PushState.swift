//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct PushState: PresenterState, Equatable {
    struct UiState: Equatable {
        var isLoading: Bool
    }

    enum Action: Actionning {
        case delayNavigate(PushDetailModel), removeLoading, pushDetail
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
