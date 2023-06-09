//
//  RestRadarApp.swift
//  RestRadar
//
//  Created by Paul Dippold on 3/5/23.
//

import SwiftUI
import RevenueCat

@main
struct RestRadarApp: App {
    init() {
        Purchases.configure(withAPIKey: "appl_smCIXKLSnkGIwEKWXWCDhfpFnrM")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }.tint(.primary)
        }
    }
}
