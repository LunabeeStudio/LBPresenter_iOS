//
//  Untitled.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

/// A protocol that defines an entity capable of managing presentation state,
/// such as presenting modals, sheets, or other transient views.
protocol Presentable {

    /// The associated type representing the scope or state of the presentation.
    ///
    /// This type must conform to `Identifiable` to ensure SwiftUI can uniquely identify
    /// and manage the presented content. Typically, this would represent the data or model
    /// associated with the presented view.
    associatedtype PresentationScope: Identifiable

    /// The current presentation scope for the conforming type.
    ///
    /// This property determines whether a presentation is active and, if so, provides the
    /// relevant data or context for the presented content. A `nil` value indicates that
    /// no presentation is currently active.
    var presentationScope: PresentationScope? { get set }
}
