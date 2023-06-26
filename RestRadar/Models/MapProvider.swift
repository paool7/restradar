//
//  MapProvider.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/23/23.
//

import Foundation
import SwiftUI
import Karte

enum MapProvider: Int, CaseIterable {
    case apple
    case google

    var name: String {
        switch self {
        case .apple:
            return "Apple"
        case .google:
            return "Google"
        }
    }
    
    var image: Image {
        switch self {
        case .apple:
            return Image(systemName: "apple.logo")
        case .google:
            return Image(systemName: "g.circle")
        }
    }
    
}
