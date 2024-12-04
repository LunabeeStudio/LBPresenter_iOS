//
//  ContentState.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import Combine
import SwiftUI

struct ContentState: PresenterState {
    typealias NavScope = DetailModel
    typealias Presentation = DetailModel

    enum UiState: Equatable {
        case loading, data(FormData, Presentation?), error(String)
    }

    struct FormData: Equatable {
        var name: String
    }

    enum Action: Sendable, Equatable {
        case navigate(DetailModel?), present(DetailModel?), fetchData, gotData(FormData, Presentation?), nameChanged(String), refreshData, error(String)
    }

    var state: UiState
    var navigationScope: NavScope? = nil
    private var presentationScope: Presentation?

    init(state: UiState) {
        self.state = state
    }
}
