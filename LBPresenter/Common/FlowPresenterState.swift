//
//  FlowPresenterState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation

/// A protocol that defines the requirements for a state object used in a `Presenter`,
/// enabling consistent management of UI state and actions.
///
/// Conforming types represent the current state of the application or feature
/// and facilitate the handling of user or system-initiated actions.
protocol FlowPresenterState: Actionnable {
    associatedtype Path: Hashable
    associatedtype Destination
}
