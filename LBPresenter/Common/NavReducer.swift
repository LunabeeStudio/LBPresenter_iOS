//
//  NavReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 11/12/2024.
//

import Foundation

@MainActor struct NavReducer<NavState: Actionnable>: Sendable {
    let navReducer: @MainActor @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void

    init(navReduce: @escaping @MainActor @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void) {
        self.navReducer = navReduce
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    func callAsFunction(_ navState: inout NavState, _ action: NavState.Action) {
        self.navReducer(&navState, action)
    }
}

@MainActor struct Reducer<State: Actionnable, NavState: Actionnable>: Sendable {
    let reducer: (_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action>

    init(reduce: @escaping (_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action>) {
        self.reducer = reduce
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    func callAsFunction(_ state: inout State, _ action: State.Action) -> Effect<State.Action, NavState.Action> {
        self.reducer(&state, action)
    }
}
