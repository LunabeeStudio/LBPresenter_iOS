//
//  Never+NavPresenterState.swift
//  LBPresenter
//
//  Created by Q2 on 16/12/2024.
//

// Extends the `Never` type to conform to the `NavPresenterState` protocol.
//
// This extension allows `Never` to be used as a placeholder for cases where
// the `NavPresenterState` protocol is required but no actual navigation state,
// path, destination, or actions are needed.
//
// - `Never` represents an uninhabited type, meaning its values can never exist.
// - Any access to the properties or types defined in this conformance will trigger
//   a runtime error, as these are logically unreachable code paths.
extension Never: NavPresenterState {
    // Conformance to the `NavPresenterState` protocol.
    // Accessing or setting `path` will cause a runtime error, as `Never` cannot have a value.
    public var path: Never {
        get { fatalError() }
        set {}
    }

    // The type representing the navigation path. Since `Never` is uninhabited,
    // this type alias resolves to `Never` itself.
    public typealias Path = Never

    // The type representing navigation destinations. This resolves to `Never`,
    // as destinations are irrelevant for `Never`.
    public typealias Destination = Never

    // The type representing navigation actions. This also resolves to `Never`,
    // as actions are not applicable for `Never`.
    public typealias Action = Never
}

extension Never: Actionning {}
