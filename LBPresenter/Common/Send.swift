//
//  Send.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 11/12/2024.
//

import SwiftUI

public struct Send<Action>: Sendable {
    let send: @MainActor (Action, Transaction?) -> Void

    public init(send: @escaping @MainActor (Action, Transaction?) -> Void) {
        self.send = send
    }

    /// Sends an action back into the system from an effect.
    ///
    /// - Parameter action: An action.
    @MainActor public func callAsFunction(_ action: Action) {
        guard !Task.isCancelled else { return }
        self.send(action, nil)
    }

    /// Sends an action back into the system from an effect with transaction.
    ///
    /// - Parameters:
    ///  - action: An action.
    ///  - transaction: A transaction.
    @MainActor public func callAsFunction(_ action: Action, transaction: Transaction) {
        guard !Task.isCancelled else { return }
        self.send(action, transaction)
    }
}
