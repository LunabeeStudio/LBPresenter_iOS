//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct SideEffectState: PresenterState, Equatable {
    enum UiState: Equatable {
        case loading, data, error
    }

    enum Action: Sendable, Equatable {
        case showLoadingThenData, showLoadingThenError, showData, showError
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
