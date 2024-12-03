//
//  Navigatable.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

/// A protocol that defines a navigatable entity, enabling the management of navigation state.
///
/// This protocol is typically used to abstract over types that maintain navigation-related data,
/// such as which screen or route is currently active within an application.
protocol Navigatable {
    /// The associated type representing the scope or state of navigation.
    ///
    /// This could be a model, an enum defining various routes, or any other type
    /// that encapsulates the current navigation context.
    associatedtype NavigationScope

    /// The current navigation scope for the conforming type.
    ///
    /// - This property defines where the navigation is currently focused
    ///   or the state relevant to the navigation flow.
    var navigationScope: NavigationScope { get set }
}
