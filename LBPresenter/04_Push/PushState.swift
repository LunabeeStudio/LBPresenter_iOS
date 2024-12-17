//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct PushState: PresenterState {
    enum UiState {
        case loading(LoadingAction.Type), ready(ReadyAction.Type)

        static let loading: UiState = .loading(LoadingAction.self)
        static let ready: UiState = .ready(ReadyAction.self)
    }

    enum LoadingAction: Actionning, Equatable {
        case cancelLoading
    }

    enum ReadyAction: Actionning, Equatable {
        case delayNavigate(PushDetailModel), removeLoading, pushDetail
    }

    var uiState: UiState

    init() {
        self.uiState = .ready(ReadyAction.self)
    }
}
