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
            return (state, .run { send in
                do {
                    try await fetchData()
                    send(.gotData(ContentState.FormData(name: "", presentationScope: nil)))
                } catch {
                    send(.error(error.localizedDescription))
                }
            })
        case .refreshData:
            return (state, .run { send in
                do {
                    try await refreshData()
                    send(.gotData(ContentState.FormData(name: "", presentationScope: nil)))
                } catch {
                    send(.error(error.localizedDescription))
                }
            })
        case .error(let error):
            return (state.update(\.state, with: .error(error)), .none)
        case .gotData(let formData):
            return (state.update(\.state, with: .data(formData)), .none)
        case .nameChanged(let name):
            switch state.state {
            case let .data(formData):
                let updatedFormData: ContentState.FormData = formData.update(\.name, with: name)
                return (state.update(\.state, with: .data(updatedFormData)), .none)
            default:
                return (state, .none)
            }
        case .navigate(nil):
            return (state.update(\.navigationScope, with: nil), .none)
        case let .navigate(model):
            return (state.update(\.navigationScope, with: model), .cancel)
        case .present(nil):
            switch state.state {
            case let .data(formData):
                let updatedFormData: ContentState.FormData = formData.update(\.presentationScope, with: nil)
                return (state.update(\.state, with: .data(updatedFormData)), .none)
            default:
                return (state, .none)
            }
        case let .present(model):
            switch state.state {
            case let .data(formData):
                let updatedFormData: ContentState.FormData = formData.update(\.presentationScope, with: model)
                return (state.update(\.state, with: .data(updatedFormData)), .cancel)
            default:
                return (state, .none)
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
