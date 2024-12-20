//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct PresentState: PresenterState, Equatable {

    enum UiState: Equatable {
        case data(PresentDetailModel?)
    }

    enum Action: Actionning {
        case present(PresentDetailModel?)
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
