//
//  ContentState.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import Combine
import SwiftUI

struct ContentState: PresenterState, Navigatable, Presentable {
    typealias NavScope = DetailModel
    typealias Presentation = DetailModel

    enum UiState: Equatable {
        case loading, data(FormData), error(String)
    }

    struct FormData: Equatable {
        var name: String
    }

    enum Action: Sendable, Equatable {
        case navigate(DetailModel?), present(DetailModel?), fetchData, gotData(FormData), nameChanged(String), refreshData, error(String)
    }

    var state: UiState
    var navigationScope: NavScope?
    var presentationScope: Presentation?

    init(navScope: NavScope? = nil, state: UiState) {
        self.navigationScope = navScope
        self.state = state
    }
}
