//
//  Theme.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/23/23.
//

import Foundation

enum Theme: Int, CaseIterable {
    case sunsetsunrise = 0
    case random = 1
    
    var name: String {
        switch self {
        case .sunsetsunrise:
            return "Sunrise to Sunset"
        case .random:
            return "Assortment"
        }
    }
}
