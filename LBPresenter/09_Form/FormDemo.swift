//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct FormDemo: View {
    @StateObject private var presenter: LBPresenter<FormState> = .init(initialState: .init(uiState: .init(formData: FormState.FormData(name: "", email: "", slider: 5, errorName: "", errorEmail: ""), bouncingState: .done)), reducer: FormReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        let uiState = presenter.state.uiState
        let formData = uiState.formData
        Form {
            TextField(text: presenter.binding(for: formData.name, send: FormState.Action.nameChanged)) {
                Text("Your name")
            }
            .autocapitalization(.none)
            .keyboardType(.namePhonePad)
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
        .navigationTitle("Bindings form")
    }
}

#Preview {
    FormDemo()
}
