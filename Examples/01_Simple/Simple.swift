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
    @Presenter(state: .init()) private var presenter: LBSimplePresenter<SimpleState>

    var body: some View {
        contentView
            .task(presenter, action: .onTask)
    }

    @ViewBuilder
    var contentView: some View {
        switch(presenter.uiState) {
        case .data:
            Button("test") {
                presenter(.click)
            }
        }
    }
}

#Preview {
    Simple()
}
