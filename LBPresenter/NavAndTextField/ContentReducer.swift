//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct ContentReducer {
    static let reducer: LBPresenter<ContentState>.Reducer = { state, action in
        switch action {
        case .fetchData:
            return .run { send in
                do {
                    try await fetchData()
                    send(.gotData(ContentState.FormData(name: ""), nil))
                } catch {
                    send(.error(error.localizedDescription))
                }
            }
        case .refreshData:
            return .run { send in
                do {
                    try await refreshData()
                    send(.gotData(ContentState.FormData(name: ""), nil))
                } catch {
                    send(.error(error.localizedDescription))
                }
            }
        case .error(let error):
            state.uiState = .error(error)
            return .none
        case let .gotData(formData, presentation):
            state.uiState = .data(formData, presentation)
            return .none
        case .nameChanged(let name):
            switch state.uiState {
            case let .data(formData, presentation):
                let updatedFormData: ContentState.FormData = formData.update(\.name, with: name)
                state.uiState = .data(updatedFormData, presentation)
            default:
                break
            }
            return .none
        case .navigate(nil):
            state.navigationScope = nil
            return .none
        case let .navigate(model):
            state.navigationScope = model
            return .cancel
        case .present(nil):
            switch state.uiState {
            case let .data(formData, _):
                state.uiState = .data(formData, nil)
            default:
                break
            }
            return .none
        case let .present(model):
            switch state.uiState {
            case let .data(formData, _):
                state.uiState = .data(formData, model)
                return .cancel
            default:
                return .none
            }
        }
    }

    private static func fetchData() async throws {
        try await Task.sleep(for: .seconds(1))
    }

    private static func refreshData() async throws {
        try await Task.sleep(for: .seconds(3))
    }
}
