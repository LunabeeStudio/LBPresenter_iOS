//
//  ContentView.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var presenter: LBPresenter<ContentState> = .init(initialState: .init(state: .loading), initialActions: [.fetchData], reducer: ContentReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            content
                .navigationDestination(item: presenter.binding(for: presenter.state.navigationScope, send: ContentState.Action.navigate)) { model in
                    Detail(model: model)
                }
        } detail: {
            Detail(model: nil)
        }
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.state {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case let .error(error):
            List {
                Text(error)
            }
            .refreshable {
                await presenter.send(.refreshData)
            }
        case let .data(formData, presentationScope):
            List {
                VStack {
                    TextField(text: presenter.binding(for: formData.name, send: ContentState.Action.nameChanged)) {
                        Text("ton nom")
                    }
                    Text(formData.name)

                    Button {
                        presenter.send(.navigate(DetailModel(id: "pushed")))
                    } label: {
                        Text("push detail")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        presenter.send(.present(DetailModel(id: "presented")))
                    } label: {
                        Text("present detail")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .refreshable {
                await presenter.send(.refreshData)
            }
            .sheet(item: presenter.binding(for: presentationScope, send: ContentState.Action.present)) { model in
                Detail(model: model)
            }
        }
    }
}

#Preview {
    ContentView()
}
