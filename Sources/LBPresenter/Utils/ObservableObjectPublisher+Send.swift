//
//  ObservableObjectPublisher+Sned.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

import Combine

// Extension to ObservableObjectPublisher to add a helper method for conditional publishing.
extension ObservableObjectPublisher {
    /// Publishes an update to notify subscribers only if the new value differs from the old value.
    ///
    /// - Parameters:
    ///   - newValue: The new value of a type conforming to the `Actionnable` protocol.
    ///   - oldValue: The previous value of the same type.
    ///
    /// This method compares the old and new values using the `isEqual(to:)` method provided
    /// by the `Actionnable` protocol. If the values are deemed equal, no notification is sent,
    /// avoiding redundant updates. If they are different, the method triggers a change notification.
    func send<T: Actionnable>(with newValue: T, oldValue: T) {
        // Use `isEqual(to:)` to compare the values. Send only if they differ.
        if oldValue.isEqual(to: newValue) {
            return // Skip sending a notification if the values are equal.
        }
        send() // Notify subscribers if the values differ.
    }
}

// Extension to add comparison functionality for `Actionnable` types.
private extension Actionnable {
    /// Determines if two instances are considered equal.
    ///
    /// - Parameter rhs: The other instance to compare to.
    /// - Returns: `true` if the instances are equal, otherwise `false`.
    ///
    /// This method checks if the instances conform to `Equatable` and compares them directly.
    /// If not, it assumes the instances are not equal.
    func isEqual(to rhs: Self) -> Bool {
        if let lhs = self as? any Equatable,
           let rhs = rhs as? any Equatable {
            return lhs.isEqual(to: rhs) // Compare using `Equatable` conformance.
        }
        return false // Default to unequal if `Equatable` is not implemented.
    }
}

// Extension to `Equatable` to enable dynamic type comparison.
private extension Equatable {
    /// Compares this instance to another dynamically typed value.
    ///
    /// - Parameter rhs: The value to compare against.
    /// - Returns: `true` if the values are equal and of the same type, otherwise `false`.
    func isEqual(to rhs: Any) -> Bool {
        guard let rhs = rhs as? Self else { return false } // Ensure the types match.
        return self == rhs // Compare using `Equatable` equality.
    }
}
