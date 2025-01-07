//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  Demonstrates how to implement a refreshable UI with SwiftUI, including task cancellation for side effects.
  
  Key Features:
  - **Refreshable**: The `List` view is configured to be refreshable using the `.refreshable` modifier. This allows the user to trigger a data refresh by pulling down the list.
  - **Canceling Tasks**: The button labeled "Cancel" allows for cancelling a task or side effect initiated previously by the presenter. This is helpful for managing long-running operations or aborting actions that are no longer needed.
  - **Side Effects**: The example shows how actions in the presenter can trigger side effects, and how they can be canceled using the `.cancel` action.
  
  Use Cases:
  - Useful for applications that need to periodically refresh data, such as fetching from a server, and also need to cancel unnecessary tasks when the user takes new actions.
  - Shows how to use the refresh gesture combined with background tasks, ensuring a seamless user experience even when dealing with async operations.
  - This pattern helps manage state and side effects in a clean, declarative manner with SwiftUI.
  
  This example helps demonstrate how to handle both refreshing data and managing cancellation of long-running tasks using a presenter-based approach.
  """

struct RefreshableAndCancellable: View {
    @StateObject private var presenter: LBPresenter<RefreshableAndCancellableState, Never> = .init(initialState: .init(uiState: .data), reducer: RefreshableAndCancellableReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        Form {
            AboutView(readMe: readMe)
            VStack {
                Button {
                    presenter.send(.cancel)
                } label: {
                    Text("cancel")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .refreshable(presenter, action: .refreshData)
    }
}

#Preview {
    RefreshableAndCancellable()
}
