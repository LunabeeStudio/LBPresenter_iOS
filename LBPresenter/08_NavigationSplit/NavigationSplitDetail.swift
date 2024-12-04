//
//  Detail.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct NavigationSplitDetailModel: Identifiable, Equatable, Hashable {
    let id: String
}

struct NavigationSplitDetail: View {
    let model: NavigationSplitDetailModel?

    var body: some View {
        Text(model?.id ?? "no data")
    }
}
