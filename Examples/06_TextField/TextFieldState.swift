//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct TextFieldState: PresenterState, Equatable {

    enum UiState: Equatable {
        case data(FormData)
    }

    struct FormData: Equatable {
        var name: String
    }

    enum Action: Sendable, Equatable {
        case nameChanged(String)
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
