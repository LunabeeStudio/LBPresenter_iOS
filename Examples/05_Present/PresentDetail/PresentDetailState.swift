//
//  PresentDetailState.swift
//  Examples
//
//  Created by Rémi Lanteri on 07/01/2025.
//

import Foundation
import SwiftUI
import LBPresenter

struct PresentDetailState: SheetPresenterState, Equatable {
    typealias Sheet = PresentDetailModel

    enum UiState: Equatable {
        case noData
        case data(PresentDetailModel)
    }

    enum Action: Actionning {
        case dismiss, dismissAll, present(Sheet?)
    }

    var uiState: UiState
    var presented: Sheet?

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
