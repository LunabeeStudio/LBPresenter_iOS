//
//  ContentState.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import Combine
import SwiftUI

struct NavAndTextFieldState: PresenterState, Navigatable {
    typealias NavScope = DetailModel
    typealias Presentation = DetailModel

    enum UiState: Equatable {
        case loading, data(FormData, Presentation?), error(String)
    }

    struct FormData: Equatable {
        var name: String
    }

    enum Action: Sendable, Equatable {
        case navigate(DetailModel?), present(DetailModel?), fetchData, gotData(FormData, Presentation?), nameChanged(String), refreshData, error(String)
    }

    var uiState: UiState
    var navigationScope: NavScope? = nil

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
