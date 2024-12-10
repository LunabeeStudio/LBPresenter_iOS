//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct TextFieldDemo: View {
    @StateObject private var presenter: LBPresenter<TextFieldState, Never> = .init(initialState: .init(uiState: .data(TextFieldState.FormData(name: ""))), reducer: TextFieldReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        switch presenter.state.uiState {
        case let .data(formData):
            List {
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
