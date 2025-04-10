//
//  PresenterPropertyWrapper.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 10/04/2025.
//

import SwiftUI

@propertyWrapper
@MainActor public struct Presenter<State: PresenterState & Sendable & Reducable>: DynamicProperty {
    @StateObject private var _lbPresenter: LBSimplePresenter<State>

    public var wrappedValue: LBSimplePresenter<State> { _lbPresenter }

    public init(state: State) {
        __lbPresenter = .init(wrappedValue: .init(initialState: state))
    }
}
