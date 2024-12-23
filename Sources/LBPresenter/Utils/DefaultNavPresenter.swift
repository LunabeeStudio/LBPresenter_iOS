//
//  DefaultNavPresenter.swift
//  LBPresenter
//
//  Created by Q2 on 23/12/2024.
//

public struct DefaultNavPresenterState<Destination: Hashable & Equatable & Sendable>: NavPresenterState, Equatable {

    public enum Action: Actionning {
        case navigate(Destination?), pop, popToRoot
    }

    public var path: [Destination]

    public init(path: [Destination] = []) {
        self.path = path
    }

    @MainActor public static func navReducer() -> NavReducer<DefaultNavPresenterState<Destination>> {
        NavReducer(navReduce: { state, action in
            guard let action = action as? DefaultNavPresenterState<Destination>.Action else { return }
            switch action {
            case let .navigate(model):
                state.navigate(to: model)
            case .pop:
                state.pop()
            case .popToRoot:
                state.popToRoot()
            }
        })
    }
}
