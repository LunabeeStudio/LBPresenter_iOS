//
//  ContentState.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct RefreshableState: PresenterState {

    enum UiState: Equatable {
        case data
    }

    enum Action: Sendable, Equatable {
        case refreshData, cancel
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
