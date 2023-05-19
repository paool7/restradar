//
//  RestRadarApp.swift
//  RestRadar
//
//  Created by Paul Dippold on 3/5/23.
//

import SwiftUI

@main
struct RestRadarApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }.tint(.primary)
        }
    }
}
