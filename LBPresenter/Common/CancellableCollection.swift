//
//  CancellableCollection.swift
//  LBPresenter
//
//  Created by Q2 on 05/12/2024.
//

import Combine
import Foundation

/// A collection for managing `AnyCancellable` subscriptions, grouped by unique identifiers.
/// This helps in organizing and canceling subscriptions efficiently.
public final class CancellablesCollection {
    // MARK: - Properties

    /// Storage for cancellables, grouped by their unique identifiers.
    private var storage: [AnyHashable: Set<AnyCancellable>] = [:]

    /// A lock to ensure thread-safe access to the storage.
    private let lock = NSLock()

    // MARK: - Methods

    /// Inserts a cancellable into the collection under a specific identifier.
    ///
    /// - Parameters:
    ///   - cancellable: The `AnyCancellable` to store.
    ///   - id: A unique identifier for grouping cancellables.
    public func insert(
        _ cancellable: AnyCancellable,
        at id: AnyHashable
    ) {
        lock.lock()
        defer { lock.unlock() }
        self.storage[id, default: []].insert(cancellable)
    }

    /// Removes a specific cancellable from the collection associated with a given identifier.
    ///
    /// - Parameters:
    ///   - cancellable: The `AnyCancellable` to remove.
    ///   - id: The identifier where the cancellable is stored.
    public func remove(
        _ cancellable: AnyCancellable,
        at id: AnyHashable
    ) {
        lock.lock()
        defer { lock.unlock() }
        self.storage[id]?.remove(cancellable)
        if self.storage[id]?.isEmpty == true {
            self.storage[id] = nil
        }
    }

    /// Cancels all cancellables associated with a specific identifier.
    ///
    /// - Parameter id: The identifier whose cancellables should be canceled.
    public func cancel(
        id: AnyHashable
    ) {
        lock.lock()
        defer { lock.unlock() }
        self.storage[id]?.forEach { $0.cancel() }
        self.storage[id] = nil
    }
}
