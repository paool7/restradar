//
//  RestRadarApp.swift
//  RestRadar
//
//  Created by Paul Dippold on 3/5/23.
//

import RevenueCat
import SwiftUI
import TelemetryClient
import GoogleMobileAds
import AppTrackingTransparency

@main
struct RestRadarApp: App {
    init() {
        Purchases.configure(withAPIKey: "appl_smCIXKLSnkGIwEKWXWCDhfpFnrM")
        let configuration = TelemetryManagerConfiguration(appID: "0C0E329B-8526-4904-91D6-941255115F8B")
        TelemetryManager.initialize(with: configuration)
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "877f3317df2fc1e25565c1682d4092cd" ]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }.tint(.primary)
        }
    }
}
