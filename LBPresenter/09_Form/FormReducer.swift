//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import Foundation

struct FormReducer {
    private enum CancelID { case bouncing }

    static let reducer: LBPresenter<FormState>.Reducer = { state, action in
        switch action {
        case .nameChanged(let name):
            if name != state.uiState.formData.name {
                state.uiState.formData.name = name
                state.uiState.formData.errorName = ""
                return .run({ send in
                    send(.bounce(.bouncing))
                    do {
                        try await Task.sleep(for: .seconds(3))
                        send(.bounce(.done))
                    } catch is CancellationError {
                        print("Task was cancelled")
                    } catch {
                        print("ooops! \(error)")
                    }
                }, cancelId: CancelID.bouncing)
            } else {
                return .none
            }
        case .emailChanged(let email):
            if (email != state.uiState.formData.email) {
                state.uiState.formData.email = email
                state.uiState.formData.errorEmail = ""
            }
            return .none
        case .sliderChanged(let slider):
            state.uiState.formData.slider = slider
            return .none
        case .validate:
            if state.uiState.formData.name.isEmpty {
                state.uiState.formData.errorName = "Name is required"
            } else {
                state.uiState.formData.errorName = ""
            }
            if state.uiState.formData.email.isEmpty {
                state.uiState.formData.errorEmail = "Email is required"
            } else if !validateEmail(state.uiState.formData.email) {
                state.uiState.formData.errorEmail = "Invalid email"
            } else {
                state.uiState.formData.errorEmail = ""
            }
            return .none
        case .bounce(let bounce):
            state.uiState.bouncingState = bounce
            return .none
        }
    }

    // Email validation function
    private static func validateEmail(_ input: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: input)
        return isValid
    }
}
