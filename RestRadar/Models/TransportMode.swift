//
//  TransportMode.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/23/23.
//

import Foundation
import SwiftUI

enum TransportMode: Int, CaseIterable {
    case walking
    case wheelchair
    
    var name: String {
        switch self {
        case .wheelchair:
            return "Wheelchair"
        case .walking:
            return "Walking"
        }
    }
    
    var image: Image {
        switch self {
        case .wheelchair:
            return Image(systemName: "figure.roll")
        case .walking:
            return Image(systemName: "figure.walk.motion")
        }
    }
    
    var verb: String {
        switch self {
        case .wheelchair:
            return "Wheel"
        case .walking:
            return "Walk"
        }
    }
    
}
