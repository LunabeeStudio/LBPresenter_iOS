//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  Demonstrates how to listen to and react to published content from external sources.
  
  Key Features:
  - **Published State**: This example shows how the `LBPresenter` listens for state changes and updates the UI accordingly. The state is published externally and observed by the view.
  - **Timer Management**: A timer is used as the published content. The view reacts to changes in the timer’s value, displaying either the current timer or a message indicating it's waiting for a timer to start.
  - **Lifecycle Handling**: The view starts observing the published content when it appears and stops observing when it disappears. This ensures that resources are managed properly.
  
  Use Cases:
  - This pattern is useful when you need to observe and respond to external data sources in real-time, such as live data feeds, timers, or updates from other parts of the app.
  - It ensures the view correctly starts and stops listening for updates, without wasting resources when the view is not visible.
  - This example demonstrates the declarative nature of SwiftUI in handling external data with minimal boilerplate, improving both performance and clarity in the codebase.
  
  This example provides an excellent starting point for handling reactive data in your SwiftUI views, while managing lifecycle events and state observation cleanly within the presenter pattern.
  """

struct PublishedDemo: View {
    @StateObject private var presenter: LBPresenter<PublishedState, Never> = .init(initialState: .init(uiState: .loading), initialActions: [.startTimer], reducer: PublishedReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        content
            .onAppear { presenter.send(.startObserve) }
            .onDisappear { presenter.send(.stopObserve) }
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.uiState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case let .data(timer):
            Form {
                AboutView(readMe: readMe)
                if let timer {
                    Text("Timer = \(timer)")
                } else {
                    Text("Waiting for timer...")
                }
                Button {
                    presenter.send(.stopTimer)
                } label: {
                    Text("Stop Timer")
                }
                .buttonStyle(.bordered)
                .disabled(timer == nil)
            }
        }
    }
}

#Preview {
    PublishedDemo()
}
