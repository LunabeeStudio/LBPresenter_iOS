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
    typealias Path = [Destination]
    
    enum Action: Actionning {
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
