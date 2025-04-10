//
//  AsyncSequenceState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation
import Combine
import SwiftUI
import LBPresenter

struct AsyncSequenceState: PresenterState, Equatable {
    enum Action: Actionning {
        case startEmitter, startObserve, didReceiveData(Date)
    }

    enum UiState: Equatable {
        case loading, data(Date)
    }

    var uiState: UiState

    init(state: UiState = .loading) {
        self.uiState = state
    }
}
