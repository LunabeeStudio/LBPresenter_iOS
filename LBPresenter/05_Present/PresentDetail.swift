//
//  Detail.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PresentDetailModel: Identifiable, Equatable, Hashable {
    let id: String
}

struct PresentDetail: View {
    let model: PresentDetailModel?

    var body: some View {
        Text(model?.id ?? "no data")
    }
}
