//
//  ContentView.swift
//  LBPresenter
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI
import LBPresenter

struct SideEffect: View {
    @StateObject private var presenter: LBPresenter<SideEffectState, Never> = .init(initialState: .init(uiState: .data), reducer: SideEffectReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        switch presenter.state.uiState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .data:
            List {
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
