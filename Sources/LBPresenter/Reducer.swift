//
//  Reducer.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import Foundation

public struct Reducer<State: Actionnable, NavState: Actionnable>: Sendable {
    let reducer: @Sendable (_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action>

    public init(reduce: @escaping @Sendable (_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action>) {
        self.reducer = reduce
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    func callAsFunction(_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action> {
        self.reducer(&state, action)
    }
}
