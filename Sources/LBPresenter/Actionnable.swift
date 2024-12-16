//
//  Actionnable.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

public protocol Actionnable {
    /// The type of actions that can be handled by the presenter.
    ///
    /// Actions represent events, user interactions, or commands that trigger
    /// changes to the state or produce side effects. Conforming types must ensure
    /// `Action` is `Sendable` to enable safe usage in asynchronous contexts.
    associatedtype Action: Sendable
}
