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

    var path: Path { get set }
}

extension FlowPresenterState where Path == [Destination] {
    mutating func navigate(to destination: Destination?) {
        if let destination {
            path.append(destination)
        } else {
            path.removeLast()
        }
    }

    mutating func pop() {
        path.removeLast()
    }

    mutating func popToRoot() {
        path.removeAll()
    }
}

extension FlowPresenterState where Path == Destination? {
    mutating func navigate(to destination: Destination?) {
        path = destination
    }

    mutating func pop() {
        path = nil
    }
}
