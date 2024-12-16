//
//  LBPresenter+BindPath.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import SwiftUI

extension LBPresenter where NavState.Path == [NavState.Destination] {
    /// Creates a SwiftUI `Binding` that observes and updates a bidirectional collection
    /// while sending an action whenever the collection's last element changes.
    ///
    /// - Parameters:
    ///   - value: The current value of the collection to bind to. Must conform to `BidirectionalCollection`.
    ///   - action: A closure that takes the last element of the collection as input
    ///             and returns an action of type `NavState.Action`.
    ///
    /// - Returns: A `Binding` for the given collection that updates its value and triggers an action when its last element changes.
    ///
    /// - Note:
    ///   This binding only reacts to changes in the last element of the collection.
    ///   The `action` is triggered only when the collection's `last` property is updated.
    public func bindPath(send action: @escaping (NavState.Path.Element?) -> NavState.Action) -> Binding<NavState.Path> {
        Binding(
            // The getter for the binding returns the current value of the collection.
            get: { self.navState.path },
            // The setter for the binding updates the collection and triggers the `action` for the last element.
            set: { [weak self] newValue, _ in
                guard let self else { return }
                // Send the action associated with the last element to the `NavState`.
                var destination: NavState.Path.Element? = newValue.last
                if newValue.count < navState.path.count { destination = nil } // pop
                self.send(navAction: action(destination))
            }
        )
    }
}
