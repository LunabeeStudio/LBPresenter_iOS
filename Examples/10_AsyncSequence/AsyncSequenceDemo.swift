//
//  AsyncSequenceView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 09/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  Demonstrates how to react to values emitted from an async sequence.
  
  This example shows how to integrate an asynchronous sequence with SwiftUI, allowing the app to:
  - **Start Listening to Async Events**: The view reacts to asynchronous values emitted by a sequence, updating the UI in real-time.
  - **Loading State**: While waiting for the data, a loading indicator is displayed.
  - **Data Handling**: Once the data is available, it updates the UI accordingly (in this case, displaying a timestamp).
  
  Key Concepts:
  - **Async Sequence Integration**: The view listens to events emitted by an asynchronous sequence using the `task` modifier. This allows for reactive UI updates based on asynchronous events.
  - **State Management**: The state updates when new values are received, triggering UI changes like showing a loading state or displaying data.
  - **Real-time Updates**: The app dynamically updates the UI when new values are emitted, ensuring the user sees the latest information.
  
  In this demo, the presenter starts observing the async sequence with the action `.startObserve`. It shows the loading state until data is available, at which point it displays the emitted value (a timestamp). This pattern is useful for handling real-time data or continuous updates (such as receiving data from a server or streaming updates).
  
  Use Case:
  - **Handling Async Data**: Ideal for cases where the UI needs to respond to values emitted from async sequences, such as real-time feeds, sensor data, or network responses.
  - **Reactive UI**: This pattern allows for a reactive user interface that automatically updates when new data is received, without requiring manual polling or refresh logic.
  """


struct AsyncSequenceDemo: View {
    @StateObject private var presenter: LBPresenter<AsyncSequenceState, Never> = .init(initialState: .init(state: .loading), initialActions: [.startEmitter], reducer: AsyncSequenceReducer.reducer)

    var body: some View {
        content
            .task(presenter, action: .startObserve)
    }

    @ViewBuilder
    var content: some View {
        let _ = Self._printChanges()
        switch presenter.state.state {
        case .loading:
            Text("Loading...")
            ProgressView()
                .progressViewStyle(.circular)
        case let .data(date):
            Form {
                AboutView(readMe: readMe)
                Text(date, format: .dateTime.hour().minute().second(.twoDigits))
            }
        }
    }
}

#Preview {
    AsyncSequenceDemo()
}
