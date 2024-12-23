//
//  PushFlowState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation
import SwiftUI
import LBPresenter

enum PushDestination: Hashable, Equatable, Sendable {
    case detail(UUID, PushDetailModel)
}

typealias PushFlowState = DefaultNavPresenterState<PushDestination>
