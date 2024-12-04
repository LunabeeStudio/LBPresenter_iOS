//
//  ContentView.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct NavigationSplit: View {
    @StateObject private var presenter: LBPresenter<NavigationSplitState> = .init(initialState: .init(uiState: .loading), initialActions: [.fetchData], reducer: NavigationSplitReducer.reducer)

    @State private var columnVisibility =
    NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView(columnVisibility: $columnVisibility) {
            content
                .navigationDestination(item: presenter.binding(for: presenter.state.navigationScope, send: NavigationSplitState.Action.navigate)) { model in
                    NavigationSplitDetail(model: model)
                }
                .toolbar(removing: .sidebarToggle)
        } detail: {
            NavigationSplitDetail(model: presenter.state.navigationScope)
        }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.uiState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case let .data(presentationScope):
            List {
                VStack {
                    Button {
                        presenter.send(.navigate(NavigationSplitDetailModel(id: "pushed")))
                    } label: {
                        Text("push detail")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        presenter.send(.present(NavigationSplitDetailModel(id: "presented")))
                    } label: {
                        Text("present detail")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .sheet(item: presenter.binding(for: presentationScope, send: NavigationSplitState.Action.present)) { model in
                NavigationSplitDetail(model: model)
            }
        }
    }
}

#Preview {
    NavigationSplit()
}
