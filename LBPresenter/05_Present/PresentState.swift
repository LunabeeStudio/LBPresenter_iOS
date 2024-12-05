//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PresentState: PresenterState {
    typealias Presentation = PresentDetailModel

    enum UiState: Equatable {
        case data(Presentation?)
    }

    enum Action: Sendable, Equatable {
        case present(PresentDetailModel?)
    }

    var uiState: UiState

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
