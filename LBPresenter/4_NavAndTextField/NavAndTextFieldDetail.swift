//
//  Detail.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct DetailModel: Identifiable, Equatable, Hashable {
    let id: String
}

struct NavAndTextFieldDetail: View {
    let model: DetailModel?

    var body: some View {
        Text(model?.id ?? "no data")
    }
}
