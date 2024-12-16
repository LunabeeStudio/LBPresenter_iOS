//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  Demonstrates how to create a form with:
  - **TextField Binding**: Each field in the form is bound to the state, allowing for two-way data binding.
  - **Field Validation**: Displays validation errors below fields if the user input is invalid.
  - **Focus Management**: Focus state is tracked, allowing for specific fields to be focused programmatically.
  - **Bouncing Behavior**: Delays network actions by detecting when the user stops typing and bouncing actions to reduce unnecessary requests.
  
  Key Features:
  - **TextField Binding**: The text fields for name and email are directly connected to the model via the presenter, allowing for automatic state updates when the user types.
  - **Real-Time Validation**: Each field has validation logic that checks for errors and displays feedback below the field when necessary. This ensures the form is always in sync with the current state.
  - **Focus Handling**: Focus is managed using `FocusState`, allowing the app to track and control which field is currently focused. The form automatically shifts focus based on user actions.
  - **Slider Binding**: The slider’s value is also bound to the state, and its changes are reflected in real-time. This allows for seamless interaction with numeric input.
  - **Bouncing Behavior**: The form includes a bouncing behavior that delays network actions when the user stops typing. This is useful for preventing excessive network requests (e.g., during form field validation).
  
  Use Cases:
  - **Form Management**: This pattern is useful for managing forms with multiple fields that require validation and focus handling.
  - **Optimizing User Input**: The bouncing behavior ensures that network requests are delayed until the user stops typing, preventing unnecessary actions during rapid typing.
  - **Real-Time Feedback**: Validation and error handling are integrated directly into the UI, providing immediate feedback to users as they fill out the form.
  
  This example demonstrates a sophisticated form that combines multiple SwiftUI features such as data binding, validation, focus management, and debounced actions, making it a great reference for complex forms.
  """

struct FormDemo: View {
    @StateObject private var presenter: LBPresenter<FormState, Never> = .init(initialState: .init(), reducer: FormReducer.reducer)

    @FocusState var focus: FormState.Field?

    var body: some View {
        let _ = Self._printChanges()
        let uiState = presenter.state.uiState
        let formData = uiState.formData
        Form {
            AboutView(readMe: readMe)
            TextField(text: presenter.binding(for: formData.name, send: FormState.Action.nameChanged)) {
                Text("Your name")
            }
            .autocapitalization(.none)
            .keyboardType(.namePhonePad)
            .focused($focus, equals: .name)
            if !formData.errorName.isEmpty {
                Text(formData.errorName)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            TextField(text: presenter.binding(for: formData.email, send: FormState.Action.emailChanged)) {
                Text("Your email")
            }
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .focused($focus, equals: .email)
            if !formData.errorEmail.isEmpty {
                Text(formData.errorEmail)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            HStack {
                Text("Slider value: \(Int(formData.slider))")
                Slider(value:  presenter.binding(for: formData.slider, send: FormState.Action.sliderChanged), in: 0...Double(10))
                    .tint(.accentColor)
            }
            Button {
                presenter.send(.validate)
            } label: {
                Text("Validate")
            }
            Text("Bouncing = \(uiState.bouncingState)")
        }
        .bind(presenter.binding(for: uiState.field, send: FormState.Action.focusChanged), to: $focus)
        .navigationTitle("Bindings form")
    }
}

#Preview {
    FormDemo()
}
