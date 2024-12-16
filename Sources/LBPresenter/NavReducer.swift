//
//  NavReducer.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 11/12/2024.
//

import Foundation

public struct NavReducer<NavState: Actionnable>: Sendable {
    let navReducer: @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void

    public init(navReduce: @escaping @Sendable (_ navState: inout NavState, _ action: NavState.Action) -> Void) {
        self.navReducer = navReduce
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    func callAsFunction(_ navState: inout NavState, _ action: NavState.Action) {
        self.navReducer(&navState, action)
    }
}
