//
//  ContentView.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct NavAndTextField: View {
    @StateObject private var presenter: LBPresenter<NavAndTextFieldState> = .init(initialState: .init(uiState: .loading), initialActions: [.fetchData], reducer: NavAndTextFieldReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            content
        } detail: {
            NavAndTextFieldDetail(model: nil)
        }
        .navigationDestination(item: presenter.binding(for: presenter.state.navigationScope, send: NavAndTextFieldState.Action.navigate)) { model in
            NavAndTextFieldDetail(model: model)
        }
    }

    @ViewBuilder
    var content: some View {
        switch presenter.state.uiState {
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
                    TextField(text: presenter.binding(for: formData.name, send: NavAndTextFieldState.Action.nameChanged)) {
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
            .sheet(item: presenter.binding(for: presentationScope, send: NavAndTextFieldState.Action.present)) { model in
                NavAndTextFieldDetail(model: model)
            }
        }
    }
}

#Preview {
    NavAndTextField()
}
