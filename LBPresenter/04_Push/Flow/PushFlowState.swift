//
//  PushFlowState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation
import SwiftUI

struct PushFlowState: FlowPresenterState, Equatable {
    typealias Path = [Destination]
    
    enum Action: Sendable, Equatable {
        case navigate(Destination), pop, popToRoot
    }

    enum Destination: Equatable, Hashable {
        case detail(PushDetailModel)
    }

    var path: [Destination]

    init(path: [Destination] = []) {
        self.path = path
    }
}
