//
//  CancellableCollection.swift
//  LBPresenter
//
//  Created by Q2 on 05/12/2024.
//
@preconcurrency import Combine

public class CancellablesCollection {
    var storage: [AnyHashable: Set<AnyCancellable>] = [:]

    func insert(
        _ cancellable: AnyCancellable,
        at id: some Hashable
    ) {
            self.storage[id, default: []].insert(cancellable)
    }

    func remove(
        _ cancellable: AnyCancellable,
        at id: some Hashable
    ) {
        self.storage[id]?.remove(cancellable)
        if self.storage[id]?.isEmpty == true {
            self.storage[id] = nil
        }
    }

    func cancel(
        id: some Hashable
    ) {
        self.storage[id]?.forEach { $0.cancel() }
        self.storage[id] = nil
    }
}
