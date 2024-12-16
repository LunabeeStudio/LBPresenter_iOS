//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PresentState: PresenterState, Equatable {

    enum UiState: Equatable {
        case data(PresentDetailModel?)
    }

    enum Action: Sendable, Equatable {
        case present(PresentDetailModel?)
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
