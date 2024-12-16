//
//  LBPresenter+BindPath.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import SwiftUI

extension LBPresenter where NavState.Path == [NavState.Destination] {
    /// Creates a SwiftUI `Binding` that synchronizes a navigation path with the presenter's state
    /// and sends an action when the path's last element changes.
    ///
    /// - Parameters:
    ///   - action: A closure that generates an action of type `NavState.Action`
    ///             based on the last element of the navigation path.
    ///
    /// - Returns: A `Binding` that updates the navigation path and triggers the provided action
    ///            when its last element changes.
    ///
    /// - Discussion:
    ///   - The `Binding` observes changes to the navigation path (`NavState.Path`) and allows
    ///     two-way updates between SwiftUI views and the presenter's state.
    ///   - The provided `action` is sent whenever the path's last element is modified, appended, or removed.
    ///   - If the path is shortened (e.g., a "pop" operation), the action is called with `nil`.
    public func bindPath(send action: @escaping (NavState.Path.Element?) -> NavState.Action) -> Binding<NavState.Path> {
        Binding(
            // The getter provides the current navigation path from the presenter's state.
            get: { self.navState.path },
            // The setter updates the navigation path and triggers the provided action.
            set: { [weak self] newValue, _ in
                guard let self else { return }

                // Determine the last element of the updated path, or nil if the path was shortened.
                var destination: NavState.Path.Element? = newValue.last
                if newValue.count < navState.path.count { destination = nil } // Handle "pop" operation

                // Send the action corresponding to the updated last element.
                self.sendNavigation(navAction: action(destination))
            }
        )
    }
}
