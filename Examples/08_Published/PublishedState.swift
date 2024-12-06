//
//  ContentState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import Foundation
import SwiftUI
import Combine

struct PublishedState: PresenterState, Equatable {

    enum UiState: Equatable {
        case loading, data(timer: Date?)
    }
    
    enum Action: Sendable, Equatable {
        case startTimer, startObserve, showData, timerDidUpdate(Date), stopObserve, stopTimer
    }

    var uiState: UiState
    var cancellables: Set<AnyCancellable> = []

    init(uiState: UiState) {
        self.uiState = uiState
    }
}
