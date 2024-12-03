//
//  ContentReducer.swift
//  LBPresenter
//
//  Created by Q2 on 03/12/2024.
//

struct ContentReducer {
    static let reducer: LBPresenter<ContentState>.Reducer = { state, action in
        var mutableState = state
        switch action {
        case .fetchData:
            return (mutableState, .run { send in
                do {
                    try await fetchData()
                    send(.gotData(ContentState.FormData(name: "")))
                } catch {
                    send(.error(error.localizedDescription))
                }
            })
        case .refreshData:
            return (mutableState, .run { send in
                do {
                    try await refreshData()
                    send(.gotData(ContentState.FormData(name: "")))
                } catch {
                    send(.error(error.localizedDescription))
                }
            })
        case .error(let error):
            mutableState.state = .error(error)
            return (mutableState, .none)
        case .gotData(let formData):
            mutableState.state = .data(formData)
            return (mutableState, .none)
        case .nameChanged(let name):
            switch mutableState.state {
            case .data(let formData):
                var mutableFormData = formData
                mutableFormData.name = name
                mutableState.state = .data(mutableFormData)
            default: break
            }
            return (mutableState, .none)
        case .navigate(nil):
            mutableState.navigationScope = nil
            return (mutableState, .none)
        case .navigate(let model):
            mutableState.navigationScope = model
            return (mutableState, .cancel)
        case .present(nil):
            mutableState.presentationScope = nil
            return (mutableState, .none)
        case .present(let model):
            mutableState.presentationScope = model
            return (mutableState, .cancel)
        }
    }

    private static func fetchData() async throws {
        try await Task.sleep(for: .seconds(1))
    }

    private static func refreshData() async throws {
        try await Task.sleep(for: .seconds(3))
    }
}
