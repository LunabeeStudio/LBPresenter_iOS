//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

private let readMe = """
  This screen demonstrates a minimal SwiftUI view structure with:
  - A single state managed by an `LBPresenter`.
  - No actions or interactivity, focusing solely on state rendering.
  - A simple "Hello World!" message displayed within a `Form`.
  
  Ideal for understanding the basics of integrating a presenter with SwiftUI.
  """

struct Simple: View {
    @StateObject private var presenter: LBPresenter<SimpleState, Never> = .init(initialState: .init(uiState: .data), reducer: SimpleReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        Form {
            AboutView(readMe: readMe)
            Text("Hello World!")
        }
    }
}

#Preview {
    Simple()
}
