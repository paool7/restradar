//
//  KarteApp+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/25/23.
//

import Foundation
import Karte

extension Karte.App {
    var supportsWalking: Bool {
        if self == .appleMaps || self == .googleMaps { return true }
        return false
    }
}
