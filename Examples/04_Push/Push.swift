//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  This example demonstrates navigation handling within a SwiftUI application using a presenter.
  
  Key Features:
  - Utilizes `NavigationStack` for seamless navigation between screens.
  - Shows how the `LBPresenter` manages navigation state and actions via the `PushReducer` and `PushFlowState`.
  - Includes examples of immediate and delayed navigation to demonstrate flexible navigation handling.
  - Displays a loading indicator when the presenter state reflects an ongoing process.
  
  Use Cases:
  - Learn how to implement navigation logic with state management in SwiftUI.
  - Understand the interaction between navigation state and UI elements in a structured, testable way.
  - Explore how delayed operations (e.g., network calls) can trigger navigation actions.
  
  This example is ideal for understanding navigation patterns in applications with complex state management and dynamic navigation flows.
  """

struct Push: View {
    @StateObject private var presenter: LBPresenter<PushState, PushFlowState> = .init(initialState: .init(uiState: .init(isLoading: false)), reducer: PushReducer.reducer, navState: .init(), navReducer: PushReducer.navReducer)

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let _ = Self._printChanges()
        NavigationStack(path: presenter.bindPath(send: PushFlowState.Action.navigate)) {
            Form {
                AboutView(readMe: readMe)
                VStack {
                    Button {
                        presenter.send(.pushDetail)
                    } label: {
                        Text("push detail")
                    }
                    .buttonStyle(.bordered)
                    Button {
                        presenter.send(.delayNavigate(PushDetailModel(id: "pushed with delay")))
                    } label: {
                        Text("push detail with delay")
                    }
                    .buttonStyle(.bordered)
                    if presenter.state.uiState.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                    }

                }
            }
            .navigationDestination(for: PushFlowState.Destination.self) { destination in
                switch destination {
                case let .detail(model):
                    PushDetail(presenter: presenter.getChild(for: .init(modelId: model.id), and: PushDetailReducer.reducer))
                }
            }
        }
    }
}

#Preview {
    Push()
}
