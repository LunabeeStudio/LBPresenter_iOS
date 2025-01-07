//
//  Actionnable.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

/// A protocol defining an entity that can handle actions.
///
/// Conforming types define a specific set of actions (`Action`) that represent
/// events, user interactions, or commands. These actions are typically used
/// to trigger state changes or initiate side effects within a presenter-driven
/// architecture.
///
/// - Note:
///   The `Action` type must conform to `Sendable` to ensure safe and predictable
///   behavior when used in asynchronous or concurrent contexts.
public protocol Actionnable {
    /// The type of actions that can be handled by the conforming type.
    ///
    /// Actions encapsulate events or operations that affect the state or
    /// trigger side effects. For example, they may represent user inputs,
    /// API requests, or navigation commands.
    associatedtype Action: Actionning
}
