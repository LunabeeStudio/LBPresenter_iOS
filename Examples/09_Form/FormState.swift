//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct FormState: PresenterState, Equatable {

    struct UiState: Equatable {
        var formData: FormData = .init(name: "", email: "", slider: 5, errorName: "", errorEmail: "")
        var bouncingState: BouncingState = .done
        var field: Field? = .name
    }

    enum BouncingState: Equatable {
        case bouncing
        case done
    }

    struct FormData: Equatable {
        var name: String
        var email: String
        var slider: Double

        var errorName: String
        var errorEmail: String
    }

    enum Field: Hashable {
        case none
        case name
        case email
    }

    enum Action: Actionning {
        case nameChanged(String), emailChanged(String), sliderChanged(Double), validate, bounce(BouncingState), focusChanged(Field?)
    }

    var uiState: UiState = .init()
}
