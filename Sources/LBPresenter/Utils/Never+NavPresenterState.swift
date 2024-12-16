//
//  Never+NavPresenterState.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

// Extension to make the `Never` type conform to the `FlowPresenterState` protocol.
extension Never: NavPresenterState {
    public var path: Never {
        get { fatalError() }
        set {}
    }

    public typealias Path = Never
    public typealias Destination = Never
    public typealias Action = Never
}
