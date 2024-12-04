//
//  Detail.swift
//  TCAV2
//
//  Created by Rémi Lanteri on 02/12/2024.
//

import SwiftUI

struct PushDetailModel: Identifiable, Equatable, Hashable {
    let id: String
}

struct PushDetail: View {
    let model: PushDetailModel?

    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Text(model?.id ?? "no data")

            Button {
                dismiss()
            } label: {
                Text("back")
            }
            .buttonStyle(.bordered)
        }
    }
}
