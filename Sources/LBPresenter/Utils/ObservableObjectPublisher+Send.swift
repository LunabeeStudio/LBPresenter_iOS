//
//  ObservableObjectPublisher+Sned.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import Combine

// Extension to ObservableObjectPublisher to add a helper method for conditional publishing
extension ObservableObjectPublisher {
    /// Sends an update to notify subscribers of changes only if the new value is different from the old value.
    ///
    /// - Parameters:
    ///   - newValue: The new value of a type conforming to the `Actionnable` protocol.
    ///   - oldValue: The previous value of the same type.
    ///
    /// This method uses the `isEqual(to:)` method from the `Actionnable` protocol to compare the old and new values.
    /// If they are equal, no notification is sent to avoid unnecessary updates. Otherwise, it triggers a change notification.
    func send<T: Actionnable>(with newValue: T, oldValue: T) {
        // Check if the old and new values are equal using the `isEqual(to:)` method.
        if oldValue.isEqual(to: newValue) {
            // If the values are equal, no changes have occurred, so exit without sending a notification.
            return
        }
        // If the values are different, notify all subscribers of the change.
        send()
    }
}

private extension Actionnable {
    /// Compares two states for equality.
    ///
    /// - Parameter rhs: The other state to compare to.
    /// - Returns: `true` if the states are considered equal, `false` otherwise.
    func isEqual(to rhs: Self) -> Bool {
        // Check if both states conform to `Equatable` and compare them directly.
        if let lhs = self as? any Equatable,
           let rhs = rhs as? any Equatable {
            return lhs.isEqual(to: rhs)
        }
        // If not `Equatable`, assume they are different.
        return false
    }
}

private extension Equatable {
    /// Compares this instance to another using dynamic type casting.
    ///
    /// - Parameter rhs: The other value to compare to.
    /// - Returns: `true` if the values are equal, `false` otherwise.
    func isEqual(to rhs: Any) -> Bool {
        guard let rhs = rhs as? Self else { return false }
        return self == rhs
    }
}
