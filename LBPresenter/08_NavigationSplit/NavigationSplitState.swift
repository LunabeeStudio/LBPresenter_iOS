//
//  ContentState.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI

struct NavigationSplitState: PresenterState, Navigatable {
    typealias NavScope = NavigationSplitDetailModel
    typealias Presentation = NavigationSplitDetailModel

    enum UiState: Equatable {
        case loading, data(Presentation?)
    }

    enum Action: Sendable, Equatable {
        case navigate(NavigationSplitDetailModel?), present(NavigationSplitDetailModel?), fetchData, gotData(Presentation?)
    }

    var uiState: UiState
    var navigationScope: NavScope? = nil

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
