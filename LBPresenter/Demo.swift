//
//  Demo.swift
//  LBPresenter
//
//  Created by Q2 on 04/12/2024.
//

import SwiftUI

struct Demo: View {
    @State private var showPushSheet = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink("Simple") {
                        Simple()
                    }
                    NavigationLink("Action") {
                        Action()
                    }
                    NavigationLink("SideEffects") {
                        SideEffect()
                    }
                    Button("Push") {
                        showPushSheet.toggle()
                    }
                    .sheet(isPresented: $showPushSheet) {
                        Push()
                    }
                    NavigationLink("Present") {
                        Present()
                    }
                    NavigationLink("TextField") {
                        TextFieldDemo()
                    }
                    NavigationLink("Refreshable") {
                        RefreshableAndCancellable()
                    }
                    NavigationLink("Published") {
                        PublishedDemo()
                    }
                    NavigationLink("Form") {
                        FormDemo()
                    }
                    NavigationLink("Async Sequence") {
                        AsyncSequenceView()
                    }
                }
            }
        }
        .navigationTitle("Demo")
    }
}
