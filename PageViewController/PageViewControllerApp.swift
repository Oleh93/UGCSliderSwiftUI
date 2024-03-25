//
//  PageViewControllerApp.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI

@main
struct PageViewControllerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}
