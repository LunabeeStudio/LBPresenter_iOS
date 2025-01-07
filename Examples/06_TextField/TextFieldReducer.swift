//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import LBPresenter

struct TextFieldReducer {
    @MainActor static let reducer: Reducer<TextFieldState, Never> = .init(reduce: { state, action in
        switch action {
        case .nameChanged(let name):
            switch state.uiState {
            case var .data(formData):
                formData.name = name
                state.uiState = .data(formData)
                return .none
            }
        }
    })
}
