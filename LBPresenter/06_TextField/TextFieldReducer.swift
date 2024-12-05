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
            case let .data(formData):
                let updatedFormData: TextFieldState.FormData = formData.update(\.name, with: name)
                return (state.update(\.uiState, with: .data(updatedFormData)), .none)
            }
        }
    }
}
