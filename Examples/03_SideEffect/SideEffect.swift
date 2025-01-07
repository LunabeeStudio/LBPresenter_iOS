//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  This example demonstrates how side effects are managed using a presenter in a SwiftUI application.
  
  Key Features:
  - The UI transitions between `loading`, `data`, and `error` states, showing how the presenter manages state updates.
  - Buttons trigger actions that simulate asynchronous operations or side effects, such as fetching data or encountering an error.
  - The `LBPresenter` handles these actions using the `SideEffectReducer`, demonstrating how effects can influence state transitions.
  
  Use Cases:
  - Learn how to model and manage side effects (e.g., network calls or async operations) in SwiftUI applications.
  - Understand the interaction between user actions, side effects, and UI state changes.
  
  This example is a foundation for building more complex side-effect-driven applications.
  """

struct SideEffect: View {
    @StateObject private var presenter: LBPresenter<SideEffectState, Never> = .init(initialState: .init(uiState: .data), reducer: SideEffectReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        switch presenter.state.uiState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .data:
            Form {
                AboutView(readMe: readMe)
                Text("Data Screen")
                Button {

                    presenter.send(.showLoadingThenData)
                } label: {
                    Text("Show Loading then Data")
                }
                .buttonStyle(.bordered)
                Button {
                    presenter.send(.showLoadingThenError)
                } label: {
                    Text("Show Loading then Error")
                }
                .buttonStyle(.bordered)
            }
        case .error:
            List {
                Text("Error Screen")
                Button {
                    presenter.send(.showLoadingThenData)
                } label: {
                    Text("Show Loading then Data")
                }
                .buttonStyle(.bordered)
                Button {
                    presenter.send(.showLoadingThenError)
                } label: {
                    Text("Show Loading then Error")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    SideEffect()
}
