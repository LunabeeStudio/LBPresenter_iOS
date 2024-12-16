//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  Demonstrates how to link a state property with a `TextField` using a binding.
  
  Key Features:
  - Uses the presenter's state (`TextFieldState`) to provide a two-way binding for the `TextField`.
  - Captures user input and updates the application state in real time via the `TextFieldState.Action.nameChanged` action.
  - Reflects changes in the state back to the UI dynamically.
  
  Use Cases:
  - Simplifies managing form inputs or user-editable data in SwiftUI.
  - Provides a clean, testable approach to synchronizing user input with state-driven UI.
  - Teaches how to structure bindings with a presenter-based architecture in SwiftUI.
  
  This example is perfect for understanding how to integrate input fields with state management to ensure a smooth and reactive user experience.
  """

struct TextFieldDemo: View {
    @StateObject private var presenter: LBPresenter<TextFieldState, Never> = .init(initialState: .init(uiState: .data(TextFieldState.FormData(name: ""))), reducer: TextFieldReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        switch presenter.state.uiState {
        case let .data(formData):
            Form {
                AboutView(readMe: readMe)
                VStack {
                    TextField(text: presenter.binding(for: formData.name, send: TextFieldState.Action.nameChanged)) {
                        Text("ton nom")
                    }
                    Text(formData.name)
                }
                .padding()
            }
        }
    }
}

#Preview {
    TextFieldDemo()
}
