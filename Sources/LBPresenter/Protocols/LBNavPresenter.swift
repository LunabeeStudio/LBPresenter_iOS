//
//  File.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 08/01/2025.
//

import Foundation

protocol LBNavPresenter: LBPresenterProtocol {
    func sendNavigation(navAction: any Actionning)
}
