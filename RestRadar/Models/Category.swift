//
//  Category.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation
import SwiftUI

enum Category: String, Equatable, CaseIterable, Identifiable, Codable {
    case library = "Library"
    case park = "Park"
    case playground = "Playground"
    case restaurant = "Restaurant"
    case store = "Store"

    var id: String { rawValue }
    
    var image: Image {
        switch self {
        case .restaurant:
            return Image(systemName: "fork.knife")
        case .store:
            return Image(systemName: "basket")
        case .park:
            return Image(systemName: "tree")
        case .library:
            return Image(systemName: "books.vertical")
        case .playground:
            return Image(systemName: "figure.play")
        }
    }
    
    var imageString: String {
        switch self {
        case .restaurant:
            return "fork.knife"
        case .store:
            return "basket"
        case .park:
            return "tree"
        case .library:
            return "books.vertical"
        case .playground:
            return "figure.play"
        }
    }
    
    var backgroundColor: Color {
        if let gradient = Gradient.forCurrentTime(), let first = gradient.stops.first?.color, let last = gradient.stops.last?.color {
            switch self {
            case .store:
                return first
            case .park:
                if gradient.stops.count >= 3 {
                    return gradient.stops[1].color
                } else {
                    return Color.blend(color1: first, intensity1: 0.33, color2: last, intensity2: 0.66)
                }
            case .library:
                if gradient.stops.count >= 4 {
                    return gradient.stops[2].color
                } else {
                    return Color.blend(color1: first, intensity1: 0.5, color2: last, intensity2: 0.5)
                }
            case .restaurant:
                if gradient.stops.count >= 5 {
                    return gradient.stops[2].color
                } else {
                    return Color.blend(color1: first, intensity1: 066, color2: last, intensity2: 0.33)
                }
            case .playground:
                return last
            }
        }
        return Gradient.iridescent.stops.first!.color
    }
}
