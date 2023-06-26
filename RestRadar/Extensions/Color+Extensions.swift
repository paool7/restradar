//
//  Color+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: 1.0
        )
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static func blend(color1: Color, intensity1: CGFloat = 0.5, color2: Color, intensity2: CGFloat = 0.5) -> Color {
        let total = intensity1 + intensity2
        
        let normalisedIntensity1 = intensity1/total
        let normalisedIntensity2 = intensity2/total
        
        guard normalisedIntensity1 > 0 else { return color2 }
        guard normalisedIntensity2 > 0 else { return color1 }
        
        let color1Components = color1.cgColor!.components!
        let color2Components = color2.cgColor!.components!
        
        let (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (color1Components[0], color1Components[1], color1Components[2], color1Components[3])
        let (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (color2Components[0], color2Components[1], color2Components[2], color2Components[3])

        return Color(red: normalisedIntensity1*r1 + normalisedIntensity2*r2,
                     green: normalisedIntensity1*g1 + normalisedIntensity2*g2,
                     blue: normalisedIntensity1*b1 + normalisedIntensity2*b2,
                     opacity: normalisedIntensity1*a1 + normalisedIntensity2*a2)
    }
    
    var accessibleFontColor: Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        return isLightColor(red: red, green: green, blue: blue) ? .black : .white
    }
    
    private func isLightColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let lightRed = red > 0.65
        let lightGreen = green > 0.65
        let lightBlue = blue > 0.65

        let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return lightness >= 2
    }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
