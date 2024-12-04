//
//  Demo.swift
//  LBPresenter
//
//  Created by Q2 on 04/12/2024.
//

import SwiftUI

struct Demo: View {
    
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
                    NavigationLink("Side Effects") {
                        SideEffect()
                    }
                    NavigationLink("Push") {
                        Push()
                    }
                    NavigationLink("Present") {
                        Present()
                    }
                    NavigationLink("TextField") {
                        TextFieldDemo()
                    }
                    NavigationLink("Refreshable") {
                        Refreshable()
                    }
                    NavigationLink("NavAndTextField") {
                        NavAndTextField()
                    }
                }
            }
        }
        .navigationTitle("Demo")
    }
}
