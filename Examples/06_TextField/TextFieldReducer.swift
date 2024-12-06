//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct TextFieldReducer {
    static let reducer: LBPresenter<TextFieldState>.Reducer = { state, action in
        switch action {
        case .nameChanged(let name):
            switch state.uiState {
            case var .data(formData):
                formData.name = name
                state.uiState = .data(formData)
                return .none
            }
        }
    }
}
