//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct ActionState: PresenterState, Equatable {

    struct UiState: Equatable {
        var count: Int
    }
    enum Action: Sendable, Equatable {
        case increment, decrement
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
