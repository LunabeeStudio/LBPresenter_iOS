//
//  ContentPresenter.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import Combine
import SwiftUI

struct ContentState: PresenterState {
    typealias NavScope = DetailModel

    enum UiState: Equatable {
        case loading, data(FormData), error(String)
    }

    struct FormData: Equatable {
        typealias Presentation = DetailModel

        var name: String
        var presentationScope: Presentation?
    }

    enum Action: Sendable, Equatable {
        case navigate(DetailModel?), present(DetailModel?), fetchData, gotData(FormData), nameChanged(String), refreshData, error(String)
    }

    var state: UiState
    var navigationScope: NavScope? = nil

    init(state: UiState) {
        self.state = state
    }
}
