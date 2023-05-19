//
//  AppIcon.swift
//  G2G
//
//  Created by Paul Dippold on 4/26/23.
//

import Foundation
import SwiftUI

enum AppIcon: String, CaseIterable, Identifiable {
    case primary = "AppIcon-7"
    case first = "AppIcon-1"
    case second = "AppIcon-2"
    case third = "AppIcon-3"
    case fourth = "AppIcon-4"
    case fifth = "AppIcon-5"
    case eigth = "AppIcon-8"
    case tenth = "AppIcon-10"
    case eleventh = "AppIcon-11"
    case thirteenth = "AppIcon-13"
    case fourteenth = "AppIcon-14"
    case fifteenth = "AppIcon-15"
    case sixteenth = "AppIcon-16"
    case seventeenth = "AppIcon-17"
    case eighteenth = "AppIcon-18"


    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .primary:
            /// `nil` is used to reset the app icon back to its primary icon.
            return nil
        default:
            return rawValue
        }
    }
}
