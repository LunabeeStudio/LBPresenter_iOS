//
//  ___FILEHEADER___
//

import LBPresenter

struct ___FILEBASENAMEASIDENTIFIER___: SheetPresenterState, Equatable {

    struct IdentifiableUUID: Identifiable, Hashable {
        let id: UUID
    }

    typealias Sheet = IdentifiableUUID

    struct UI___VARIABLE_productName:identifier___: Equatable {
    }

    enum UiState: Equatable {
        case idle, data(UI___VARIABLE_productName:identifier___)
    }

    enum Action: Actionning {
        case 
    }

    var uiState: UiState = .idle
    var presented: Sheet? = nil
}
