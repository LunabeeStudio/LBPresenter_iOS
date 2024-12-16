//
//  Reducer.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import Foundation

/// A structure representing a reducer, which defines how to handle actions
/// and compute the next state along with potential side effects.
///
/// A `Reducer` encapsulates the logic for updating the application's state
/// and triggering side effects in response to user or system-initiated actions.
/// It operates within the context of two state types: a primary state (`State`)
/// and an optional navigation-related state (`NavState`), allowing seamless handling
/// of both business logic and navigation actions.
///
/// ## Example
/// ```swift
/// let reducer = Reducer<AppState, NavState> { state, action in
///     switch action {
///     case .increment:
///         state.count += 1
///         return .none
///     case .navigateToDetail:
///         return .run { send, sendNavigation in
///             sendNavigation(.showDetail)
///         }
///     }
/// }
/// ```
public struct Reducer<State: Actionnable, NavState: Actionnable>: Sendable {

    /// The underlying reducer function that takes the current state and an action,
    /// updates the state in place, and returns an effect to handle side effects.
    let reducer: @Sendable (_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action>

    /// Initializes a new `Reducer` with the specified reducer logic.
    ///
    /// - Parameter reduce: A closure that defines how to update the state
    ///   and produce side effects based on the given action.
    public init(reduce: @escaping @Sendable (_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action>) {
        self.reducer = reduce
    }

    /// Executes the reducer logic by processing an action, updating the state, and returning an effect.
    ///
    /// This method applies the reducer's logic to compute the next state of the application
    /// and determine if any side effects should be executed.
    ///
    /// - Parameters:
    ///   - state: The current state of the application, which will be updated in place.
    ///   - action: The action to process, representing an event or command to handle.
    /// - Returns: An `Effect` describing any side effects to execute, such as additional actions
    ///   to dispatch or operations to cancel.
    func callAsFunction(_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action> {
        self.reducer(&state, action)
    }
}
