//
//  DistanceUnit.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/23/23.
//

import Foundation
import SwiftUI

enum DistanceMeasurement: Int, CaseIterable {
    case blocks
    case steps
    case milesfeet
    case meterskilometers

    var name: String {
        switch self {
        case .milesfeet:
            return "Feet / Miles"
        case .blocks:
            return "Blocks"
        case .steps:
            return "Steps"
        case .meterskilometers:
            return "Meters / Kilometers"
        }
    }
    
    var image: Image {
        switch self {
        case .milesfeet, .meterskilometers:
            return Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
        case .blocks:
            return Image(systemName: "building.2")
        case .steps:
            return Image(systemName: "shoeprints.fill")
        }
    }
}
