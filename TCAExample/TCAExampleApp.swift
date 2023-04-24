//
//  TCAExampleApp.swift
//  TCAExample
//
//  Created by Junhee Yoon on 2023/04/24.
//

import SwiftUI

import ComposableArchitecture

@main
struct TCAExampleApp: App {
    var body: some Scene {
        WindowGroup {
            InitialView(store: Store(initialState: Initial.State(),
                                     reducer: Initial()))
        }
    }
}
