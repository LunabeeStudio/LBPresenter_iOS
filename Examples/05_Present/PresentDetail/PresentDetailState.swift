//
//  PresentDetailState.swift
//  Examples
//
//  Created by Rémi Lanteri on 07/01/2025.
//

import Foundation
import SwiftUI
import LBPresenter

struct PresentDetailState: PresenterState, Equatable {

    enum UiState: Equatable {
        case noData
        case data(PresentDetailModel)
    }

    enum Action: Actionning {
        case dismiss
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
