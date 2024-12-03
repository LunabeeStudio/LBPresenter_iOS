//
//  Detail.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct DetailModel: Identifiable, Equatable, Hashable, Codable {
    let id: String
}

struct Detail: View {
    let model: DetailModel?

    var body: some View {
        VStack {
            Text(model?.id ?? "no data")
        }
    }
}
