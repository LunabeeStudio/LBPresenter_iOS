//
//  NavReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 11/12/2024.
//

import Foundation
import SwiftUI

typealias SendAction = @MainActor (Actionning, Transaction?) -> Void

struct NavReducer<NavState: Actionnable>: Sendable {
    let navReducer: @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void

    init(navReduce: @escaping @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void) {
        self.navReducer = navReduce
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    func callAsFunction(_ navState: inout NavState, _ action: NavState.Action) {
        self.navReducer(&navState, action)
    }
}

struct Reducer<State: PresenterState, NavState: Actionnable>: Sendable {
    let reducer: @Sendable (_ state: inout State, _ action: Actionning, _ sendAction: @escaping SendAction) -> Effect<Actionning, NavState.Action>

    init(reduce: @escaping @Sendable (_ state: inout State, _ action: Actionning, _ sendAction: @escaping SendAction) -> Effect<Actionning, NavState.Action>) {
        self.reducer = { state, action, sendAction in
            reduce(&state, action, sendAction)
        }
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    func callAsFunction(_ state: inout State, _ action: Actionning, _ sendAction: @escaping SendAction) -> Effect<Actionning, NavState.Action> {
//        guard let action = action as? State.Action else {
//            print("WARNING: Did not send a valid state action")
//            return .none
//        }
        return self.reducer(&state, action, sendAction)
    }
}
