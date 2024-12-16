//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  This example demonstrates how to present a new screen conditionally based on the application's state.
  
  Key Features:
  - Leverages SwiftUI's `.sheet` modifier to present a new screen modally.
  - Uses the presenter's state (`PresentState`) to control when the presentation occurs.
  - Includes a binding mechanism that seamlessly synchronizes state changes with the UI.
  
  Use Cases:
  - Dynamically present a detail view only when specific data is available.
  - Learn how to use presenters to manage modal presentations in a structured and testable way.
  - Understand the role of state-driven UI updates in managing complex screen flows.
  
  This example is ideal for understanding modal presentations and how they can be tied to a state management system in SwiftUI.
  """

struct Present: View {
    @StateObject private var presenter: LBPresenter<PresentState, Never> = .init(initialState: .init(uiState: .data( nil)), reducer: PresentReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        content
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.uiState {
        case let .data(presentationScope):
            Form {
                AboutView(readMe: readMe)
                VStack {
                    Button {
                        presenter.send(.present(PresentDetailModel(id: "presented")))
                    } label: {
                        Text("present detail")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .sheet(item: presenter.binding(for: presentationScope, send: PresentState.Action.present)) { model in
                PresentDetail(model: model)
            }
        }
    }
}

#Preview {
    Present()
}
