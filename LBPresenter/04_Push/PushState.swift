//
//  ContentState.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushState: PresenterState, Navigatable {
    typealias NavScope = PushDetailModel

    struct UiState: Equatable {}

    enum Action: Sendable, Equatable {
        case navigate(PushDetailModel?)
    }

    var uiState: UiState
    var navigationScope: NavScope? = nil

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
