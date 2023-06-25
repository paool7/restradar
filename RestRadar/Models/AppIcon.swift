//
//  AppIcon.swift
//  G2G
//
//  Created by Paul Dippold on 4/26/23.
//

import Foundation
import SwiftUI

enum AppIcon: String, CaseIterable, Identifiable {
    case primary = "Primary"
    case first = "AppIcon-1"
    case second = "AppIcon-2"
    case third = "AppIcon-3"
    case fourth = "AppIcon-4"
    case fifth = "AppIcon-5"
    case sixth = "AppIcon-6"
    case seventh = "AppIcon-7"
    case eigth = "AppIcon-8"
    case ninth = "AppIcon-9"
    case tenth = "AppIcon-10"
    case eleventh = "AppIcon-11"
    case twelfth = "AppIcon-12"
    case thirtheend = "AppIcon-13"

    var id: String { rawValue }
    
    var iconName: String? {
        switch self {
        case .primary:
            return nil
        default:
            return rawValue
        }
    }
}
