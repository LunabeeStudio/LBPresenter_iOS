//
//  View+NavigationDestination.swift
//  LBPresenter
//
//  Created by Q2 on 07/01/2025.
//

import SwiftUI

public extension View {
    func navigationDestination<T: Hashable & Sendable>(destination: @escaping (T, UUID) -> some View) -> some View {
        self.navigationDestination(for: Destinable<T>.self) { destinable in
            destination(destinable.destination, destinable.uniqueId)
        }
    }
}
