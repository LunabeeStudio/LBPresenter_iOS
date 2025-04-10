//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct SimpleState: PresenterState {
    enum UiState {
        case data
    }

    enum Action: Actionning {
        case click, onTask
    }

    var uiState: UiState = .data
}

extension SimpleState: Reducable {
    static func reduce(_ state: inout SimpleState, _ action: SimpleState.Action) -> SimpleEffect<SimpleState.Action> {
        switch action {
        case .click, .onTask:
            return .none
        }
    }
}
