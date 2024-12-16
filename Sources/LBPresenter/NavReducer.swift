//
//  NavReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 11/12/2024.
//

import Foundation

/// A generic reducer for managing navigation-related state transitions.
///
/// The `NavReducer` encapsulates the logic for updating a navigation state (`NavState`)
/// in response to a specific navigation action (`NavState.Action`). It provides a reusable,
/// type-safe mechanism to handle navigation transitions, enabling clean separation
/// of state mutation logic.
///
/// ## Type Parameters
/// - `NavState`: A type conforming to `Actionnable` that represents the navigation state.
///   This includes the current path, destination, and any other navigation-related properties.
public struct NavReducer<NavState: Actionnable>: Sendable {

    /// The closure that defines how the navigation state is updated for a given action.
    ///
    /// This closure mutates the navigation state (`NavState`) based on the received action (`NavState.Action`),
    /// implementing the logic for transitions such as navigating to a destination, popping a screen, or resetting the stack.
    let navReducer: @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void

    /// Initializes a `NavReducer` with a custom state mutation logic.
    ///
    /// - Parameter navReduce: A closure defining the reducer logic for updating the navigation state
    ///   in response to a specific navigation action.
    public init(navReduce: @escaping @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void) {
        self.navReducer = navReduce
    }

    /// Invokes the reducer logic to update the navigation state with a given action.
    ///
    /// This method applies the reducer's state mutation logic (`navReducer`) to the provided navigation state,
    /// enabling transitions such as navigation, stack updates, or other custom behaviors.
    ///
    /// - Parameters:
    ///   - navState: The current navigation state to be mutated.
    ///   - action: The navigation action that triggers a state update.
    func callAsFunction(_ navState: inout NavState, _ action: NavState.Action) {
        self.navReducer(&navState, action)
    }
}
