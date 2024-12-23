//
//  PushFlowState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

struct PushFlowState: NavPresenterState, Equatable {

    enum Action: Actionning {
        case navigate(Destination?), pop, popToRoot
    }

    enum Destination: Equatable, Hashable {
        case detail(PushDetailModel)
    }

    var path: [Destination]

    init(path: [Destination] = []) {
        self.path = path
    }
}
