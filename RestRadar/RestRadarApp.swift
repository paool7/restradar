//
//  RestRadarApp.swift
//  RestRadar
//
//  Created by Paul Dippold on 3/5/23.
//

import RevenueCat
import SwiftUI
import TelemetryClient

@main
struct RestRadarApp: App {
    init() {
        Purchases.configure(withAPIKey: "appl_smCIXKLSnkGIwEKWXWCDhfpFnrM")
        let configuration = TelemetryManagerConfiguration(appID: "0C0E329B-8526-4904-91D6-941255115F8B")
        TelemetryManager.initialize(with: configuration)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }.tint(.primary)
        }
    }
}
