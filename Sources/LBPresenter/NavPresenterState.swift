//
//  FlowPresenterState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import Foundation

/// A protocol that defines the requirements for navigation-aware state objects used in a `Presenter`.
///
/// This protocol extends `Actionnable` to incorporate navigation-specific capabilities,
/// enabling consistent management of UI state, navigation paths, and actions.
///
/// Conforming types:
/// - Represent the current state of a navigable feature or application.
/// - Facilitate the handling of navigation paths, destinations, and user or system-initiated actions.
///
/// ## Associated Types:
/// - `Path`: A type that represents the navigation path. This can be a stack (`[Destination]`) or a single value (`Destination?`).
/// - `Destination`: A type that represents a specific navigation target.
public protocol NavPresenterState: Actionnable, Equatable {
    /// The type representing the navigation path. Typically:
    /// - `[Destination]` for stack-based navigation.
    /// - `Destination?` for single-destination navigation.
    associatedtype Path: Hashable

    /// The type representing a specific navigation target or screen.
    associatedtype Destination

    /// The navigation path, which defines the current state of navigation.
    var path: Path { get set }
}

// MARK: - Extensions for Stack-Based Navigation
extension NavPresenterState where Path == [Destination] {
    /// Navigates to a specific destination or pops the current path if the destination is `nil`.
    ///
    /// - Parameter destination: The destination to navigate to. If `nil`, the method will pop the current path.
    public mutating func navigate(to destination: Destination?) {
        if let destination {
            path.append(destination) // Push the destination onto the navigation stack.
        } else {
            pop() // Pop the current destination if `nil` is provided.
        }
    }

    /// Removes the last destination from the navigation stack, effectively "popping" the stack.
    public mutating func pop() {
        path.removeLast()
    }

    /// Clears the navigation stack, effectively resetting it to the root.
    public mutating func popToRoot() {
        path.removeAll()
    }
}

// MARK: - Extensions for Single-Destination Navigation
extension NavPresenterState where Path == Destination? {
    /// Sets the navigation path to the specified destination or clears it if `nil`.
    ///
    /// - Parameter destination: The new destination. If `nil`, the navigation path is cleared.
    mutating func navigate(to destination: Destination?) {
        path = destination
    }

    /// Clears the navigation path, effectively "popping" the current destination.
    mutating func pop() {
        path = nil
    }
}
