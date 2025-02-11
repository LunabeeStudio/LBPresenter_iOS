//
//  File.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 08/01/2025.
//

import Foundation

@MainActor
protocol LBSheetPresenter {
    var presentedChild: (any LBPresenterProtocol)? { get set }
    func dismiss()
    func dismissAll()
}
