//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushState: PresenterState, Equatable {

    struct UiState: Equatable {
        var isLoading: Bool
    }

    enum Action: Sendable, Equatable {
        case navigate(PushDetailModel?), delayNavigate(PushDetailModel), removeLoading, pop
    }

    var uiState: UiState
    var navigationScope: PushDetailModel? = nil

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
