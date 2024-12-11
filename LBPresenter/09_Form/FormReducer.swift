//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

import Foundation

struct FormReducer {
    private enum CancelID: String { case bouncing }

    static let reducer: LBPresenter<FormState, Never>.Reducer = { state, action in
        switch action {
        case .nameChanged(let name):
            if name != state.uiState.formData.name {
                state.uiState.formData.name = name
                state.uiState.formData.errorName = ""
                return .run({ send, _ in
                    send(.bounce(.bouncing))
                    do {
                        try await Task.sleep(for: .seconds(3))
                        send(.bounce(.done))
                    } catch is CancellationError {
                        print("Task was cancelled")
                    } catch {
                        print("ooops! \(error)")
                    }
                }, cancelId: CancelID.bouncing.rawValue)
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
            var nextFocus: FormState.Field? = nil
            if state.uiState.formData.email.isEmpty {
                state.uiState.formData.errorEmail = "Email is required"
                nextFocus = .email
            } else if !validateEmail(state.uiState.formData.email) {
                state.uiState.formData.errorEmail = "Invalid email"
                nextFocus = .email
            } else {
                state.uiState.formData.errorEmail = ""
            }
            if state.uiState.formData.name.isEmpty {
                state.uiState.formData.errorName = "Name is required"
                nextFocus = .name
            } else {
                state.uiState.formData.errorName = ""
            }
            state.uiState.field = nextFocus
            return .none
        case .bounce(let bounce):
            state.uiState.bouncingState = bounce
            return .none
        case .focusChanged(let field):
            state.uiState.field = field
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
