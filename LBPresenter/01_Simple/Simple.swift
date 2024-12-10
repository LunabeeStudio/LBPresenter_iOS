//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct Simple: View {
    @StateObject private var presenter: LBPresenter<SimpleState, Never> = .init(initialState: .init(uiState: .data), reducer: SimpleReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        List {
            Text("Hello World!")
        }
    }
}

#Preview {
    Simple()
}
