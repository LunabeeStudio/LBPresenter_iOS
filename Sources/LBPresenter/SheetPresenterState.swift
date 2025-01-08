//
//  SheetPresenterState.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 07/01/2025.
//

import Foundation

public protocol SheetPresenterState: Actionnable, Equatable {
    associatedtype Sheet: Hashable & Sendable

    var presented: Sheet? { get set }
}

public extension SheetPresenterState {
    mutating func present(_ sheet: Sheet) {
        presented = sheet
    }

    mutating func dismiss() {
        presented = nil
    }
}
