//
//  ___FILEHEADER___
//

import LBPresenter

struct ___FILEBASENAMEASIDENTIFIER___: PresenterState, Equatable {

    struct UI___VARIABLE_productName:identifier___: Equatable {
    }

    enum UiState: Equatable {
        case idle, data(UI___VARIABLE_productName:identifier___)
    }

    enum Action: Actionning {
        case
    }

    var uiState: UiState = .idle
}
