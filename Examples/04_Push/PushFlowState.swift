//
//  PushFlowState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct PushFlowState: FlowPresenterState, Equatable {
    typealias Path = [Destination]
    
    enum Action: Sendable, Equatable {
        case navigate(Destination?), pop, popToRoot
    }

    enum Destination: Equatable, Hashable {
        case detail(PushDetailModel)
    }

    var path: Path

    init(path: Path = []) {
        self.path = path
    }
}
