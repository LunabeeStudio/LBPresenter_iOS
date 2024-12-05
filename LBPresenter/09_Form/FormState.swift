//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct FormState: PresenterState, Equatable {

    struct UiState: Equatable {
        var formData: FormData
        var bouncingState: BouncingState
    }

    enum BouncingState: Equatable {
        case bouncing
        case stopped
        case done
    }

    struct FormData: Equatable {
        var name: String
        var email: String
        var slider: Double

        var errorName: String
        var errorEmail: String
     }

    enum Action: Sendable, Equatable {
        case nameChanged(String), emailChanged(String), sliderChanged(Double), validate
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
