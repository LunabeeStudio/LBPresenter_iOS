//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct SimpleState: PresenterState {

    enum UiState: Equatable {
        case data
    }
    enum Action: Sendable, Equatable {}

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
