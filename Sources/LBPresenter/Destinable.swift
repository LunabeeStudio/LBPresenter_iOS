//
//  Destinable.swift
//  LBPresenter
//
//  Created by Q2 on 07/01/2025.
//

import Foundation

public struct Destinable<Destination: Sendable & Hashable>: Hashable, Sendable {
    let uniqueId: UUID = .init()
    let destination: Destination
}
