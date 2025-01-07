//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct PresentState: SheetPresenterState, Equatable {
    typealias Sheet = PresentDetailModel

    enum UiState: Equatable {
        case data
    }

    enum Action: Actionning {
        case present(Sheet?)
    }

    var uiState: UiState
    var presented: Sheet?

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
