//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct SimpleState: PresenterState, Equatable {

    enum UiState: Equatable {
        case data
    }
    enum Action: Sendable, Equatable {}

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
