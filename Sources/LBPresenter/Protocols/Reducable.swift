//
//  Reducable.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 10/04/2025.
//

public protocol Reducable: Actionnable {
    static func reduce(_ state: inout Self, _ action: Action) -> SimpleEffect<Action>
}
