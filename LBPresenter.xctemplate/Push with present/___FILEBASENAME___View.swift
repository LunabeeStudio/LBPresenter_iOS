//
//  ___FILEHEADER___
//

import SwiftUI
import LBPresenter

struct ___FILEBASENAMEASIDENTIFIER___: View {
    @StateObject var presenter: LBPresenter<___VARIABLE_productName:identifier___State, ___VARIABLE_productName:identifier___NavState> = .init(initialState: .init(), reducer: ___VARIABLE_productName:identifier___Reducer.reducer, navState: .init(), navReducer: ___VARIABLE_productName:identifier___NavState.navReducer()))

    var body: some View {
        contentView
    }

    @ViewBuilder
    private var contentView: some View {
        switch presenter.state.uiState {
        case .idle:
            ProgressView()
        case .data(let data):
        }
    }
}
