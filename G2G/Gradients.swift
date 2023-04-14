//
//  Gradients.swift
//  G2G
//
//  Created by Paul Dippold on 4/11/23.
//

import SwiftUI
import Solar
import MapKit

extension Gradient {
    static func gradient(forHour: Int) -> LinearGradient {
        if forHour < 24 {
            return dimAlternateGradients[forHour] //alternateGradients[forHour]
        }
        switch forHour {
        case 0: return Gradient.skyGradient0
        case 1: return Gradient.skyGradient1
        case 2: return Gradient.skyGradient2
        case 3: return Gradient.skyGradient3
        case 4: return Gradient.skyGradient4
        case 5: return Gradient.skyGradient5
            //Sunrise
        case 6: return Gradient.skyGradient6
        case 7: return Gradient.skyGradient7
        case 8: return Gradient.skyGradient8
        case 9: return Gradient.skyGradient9
        case 10: return Gradient.skyGradient10
        case 11: return Gradient.skyGradient11
        case 12: return Gradient.skyGradient12
        case 13: return Gradient.skyGradient13
        case 14: return Gradient.skyGradient14
        case 15: return Gradient.skyGradient15
        case 16: return Gradient.skyGradient16
        case 17: return Gradient.skyGradient17
        case 18: return Gradient.skyGradient18
            // Sunset
        case 19: return Gradient.skyGradient19
        case 20: return Gradient.skyGradient20
        case 21: return Gradient.skyGradient21
        case 22: return Gradient.skyGradient22
        case 23: return Gradient.skyGradient23
        default: return Gradient.skyGradient23
        }
    }
    
    static let alternateGradients = [LinearGradient(gradient: Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255), Color(red: 22/255, green: 27/255, blue: 54/255)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255), Color(hex: "20202c")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255), Color(hex: "3a3a52")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "20202c"), Color(hex: "515175")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "40405c"), Color(hex: "6f71aa"), Color(hex: "8a76ab")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "4a4969"), Color(hex: "7072ab"), Color(hex: "cd82a0")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "757abf"), Color(hex: "8583be"), Color(hex: "eab0d1")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "82addb"), Color(hex: "ebb2b1")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "94c5f8"), Color(hex: "a6e6ff"), Color(hex: "b1b5ea")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "b7eaff"), Color(hex: "94dfff")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "9be2fe"), Color(hex: "67d1fb")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "90dffe"), Color(hex: "38a3d1")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "57c1eb"), Color(hex: "246fa8")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "2d91c2"), Color(hex: "1e528e")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "2473ab"), Color(hex: "1e528e"), Color(hex: "5b7983")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "1e528e"), Color(hex: "265889"), Color(hex: "9da671")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "1e528e"), Color(hex: "728a7c"), Color(hex: "e9ce5d")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "154277"), Color(hex: "576e71"), Color(hex: "e1c45e"), Color(hex: "b26339")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(hex: "154277"), Color(hex: "576e71"), Color(hex: "e1c45e"), Color(hex: "b26339")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(hex: "163C52"), Color(hex: "4F4F47"), Color(hex: "C5752D"), Color(hex: "B7490F"), Color(hex: "2F1107")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(hex: "163C52"), Color(hex: "59230B"), Color(hex: "2F1107")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255), Color(hex: "163C52"), Color(hex: "59230B"), Color(hex: "2F1107")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255), Color(hex: "4B1D06")]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255), Color(red: 22/255, green: 27/255, blue: 54/255)]), startPoint: .top, endPoint: .bottom)]
    
    static let opacity = 0.7
    
    static let dimAlternateGradients = [LinearGradient(gradient: Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity), Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity), Color(hex: "20202c")]), startPoint: .top, endPoint: .bottom),
                                        LinearGradient(gradient: Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity), Color(hex: "3a3a52").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "20202c").opacity(opacity), Color(hex: "515175").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "40405c").opacity(opacity), Color(hex: "6f71aa").opacity(opacity), Color(hex: "8a76ab").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "4a4969").opacity(opacity), Color(hex: "7072ab").opacity(opacity), Color(hex: "cd82a0").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "757abf").opacity(opacity), Color(hex: "8583be").opacity(opacity), Color(hex: "eab0d1").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "82addb").opacity(opacity), Color(hex: "ebb2b1").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "94c5f8").opacity(opacity), Color(hex: "a6e6ff").opacity(opacity), Color(hex: "b1b5ea").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "b7eaff").opacity(opacity), Color(hex: "94dfff").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "9be2fe").opacity(opacity), Color(hex: "67d1fb").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "90dffe").opacity(opacity), Color(hex: "38a3d1").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "57c1eb").opacity(opacity), Color(hex: "246fa8").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "2d91c2").opacity(opacity), Color(hex: "1e528e").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "2473ab").opacity(opacity), Color(hex: "1e528e").opacity(opacity), Color(hex: "5b7983").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "1e528e").opacity(opacity), Color(hex: "265889").opacity(opacity), Color(hex: "9da671").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "1e528e").opacity(opacity), Color(hex: "728a7c").opacity(opacity), Color(hex: "e9ce5d").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient: Gradient(colors: [Color(hex: "154277").opacity(opacity), Color(hex: "576e71").opacity(opacity), Color(hex: "e1c45e").opacity(opacity), Color(hex: "b26339").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(hex: "154277").opacity(opacity), Color(hex: "576e71").opacity(opacity), Color(hex: "e1c45e").opacity(opacity), Color(hex: "b26339").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(hex: "163C52").opacity(opacity), Color(hex: "4F4F47").opacity(opacity), Color(hex: "C5752D").opacity(opacity), Color(hex: "B7490F").opacity(opacity), Color(hex: "2F1107").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(hex: "163C52").opacity(opacity), Color(hex: "59230B").opacity(opacity), Color(hex: "2F1107").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity), Color(hex: "163C52").opacity(opacity), Color(hex: "59230B").opacity(opacity), Color(hex: "2F1107").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity), Color(hex: "4B1D06").opacity(opacity)]), startPoint: .top, endPoint: .bottom),
        LinearGradient(gradient:Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity), Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity)]), startPoint: .top, endPoint: .bottom)]
    
    static let skyGradient0 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 0),
            .init(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient1 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 0.6),
            .init(color: Color(red: 58/255, green: 58/255, blue: 82/255), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient2 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 0.3),
            .init(color: Color(red: 58/255, green: 58/255, blue: 82/255), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient3 = LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 0.1), Gradient.Stop(color: Color(red: 58/255, green: 58/255, blue: 82/255), location: 1)]), startPoint: .top, endPoint: .bottom)
    
    static let skyGradient4 = LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(red: 32/255, green: 32/255, blue: 44/255), location: 0), Gradient.Stop(color: Color(red: 81/255, green: 81/255, blue: 117/255), location: 1)]), startPoint: .top, endPoint: .bottom)
    
    static let skyGradient5 = LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(red: 64/255, green: 64/255, blue: 92/255), location: 0), Gradient.Stop(color: Color(red: 111/255, green: 113/255, blue: 170/255), location: 0.8), Gradient.Stop(color: Color(red: 138/255, green: 118/255, blue: 171/255), location: 1)]), startPoint: .top, endPoint: .bottom)
    
    static let skyGradient6 = LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(red: 74/255, green: 73/255, blue: 105/255), location: 0), Gradient.Stop(color: Color(red: 112/255, green: 114/255, blue: 171/255), location: 0.5), Gradient.Stop(color: Color(red: 205/255, green: 130/255, blue: 160/255), location: 1)]), startPoint: .top, endPoint: .bottom)
    
    static let skyGradient7 = LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(red: 117/255, green: 122/255, blue: 191/255), location: 0), Gradient.Stop(color: Color(red: 133/255, green: 131/255, blue: 190/255), location: 0.6), Gradient.Stop(color: Color(red: 234/255, green: 176/255, blue: 209/255), location: 1)]), startPoint: .top, endPoint: .bottom)
    
    static let skyGradient8 = LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(red: 130/255, green: 173/255, blue: 219/255), location: 0), Gradient.Stop(color: Color(red: 235/255, green: 178/255, blue: 177/255), location: 1)]), startPoint: .top, endPoint: .bottom)
    
    static let skyGradient9 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 148/255, green: 197/255, blue: 248/255), location: 0.01),
        .init(color: Color(red: 166/255, green: 230/255, blue: 255/255), location: 0.7),
        .init(color: Color(red: 177/255, green: 181/255, blue: 234/255), location: 1.0)
    ]),startPoint: .top,endPoint: .bottom)
    
    static let skyGradient10 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 183/255, green: 234/255, blue: 255/255), location: 0.0),
        .init(color: Color(red: 148/255, green: 223/255, blue: 255/255), location: 1.0)
    ]),startPoint: .top,endPoint: .bottom)
    
    static let skyGradient11 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 155/255, green: 226/255, blue: 254/255), location: 0.0),
        .init(color: Color(red: 103/255, green: 209/255, blue: 251/255), location: 1.0)
    ]),startPoint: .top,endPoint: .bottom)
    
    static let skyGradient12 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 144/255, green: 223/255, blue: 254/255), location: 0.0),
        .init(color: Color(red: 56/255, green: 163/255, blue: 209/255), location: 1.0)
    ]),startPoint: .top,endPoint: .bottom)
    
    static let skyGradient13 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 87/255, green: 193/255, blue: 235/255), location: 0.0),
        .init(color: Color(red: 36/255, green: 111/255, blue: 168/255), location: 1.0)
    ]),startPoint: .top,endPoint: .bottom)
    
    static let skyGradient14 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 45/255, green: 145/255, blue: 194/255), location: 0.0),
        .init(color: Color(red: 30/255, green: 82/255, blue: 142/255), location: 1.0)
    ]),startPoint: .top,endPoint: .bottom)
    
    static let skyGradient15 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 36/255, green: 115/255, blue: 171/255), location: 0.0),
        .init(color: Color(red: 30/255, green: 82/255, blue: 142/255), location: 0.7),
        .init(color: Color(red: 91/255, green: 121/255, blue: 131/255), location: 1.0)
    ]),startPoint: .top, endPoint: .bottom)
    
    static let skyGradient16 = LinearGradient(gradient:Gradient(stops: [
        .init(color: Color(red: 30/255, green: 82/255, blue: 142/255), location: 0.0),
        .init(color: Color(red: 38/255, green: 88/255, blue: 137/255), location: 0.5),
        .init(color: Color(red: 157/255, green: 166/255, blue: 113/255), location: 1.0)
    ]),startPoint: .top, endPoint: .bottom)
    
    static let skyGradient17 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 0.12, green: 0.32, blue: 0.56), location: 0),
            .init(color: Color(red: 0.45, green: 0.54, blue: 0.49), location: 0.5),
            .init(color: Color(red: 0.91, green: 0.81, blue: 0.36), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient18 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 0.08, green: 0.26, blue: 0.47), location: 0),
            .init(color: Color(red: 0.34, green: 0.43, blue: 0.44), location: 0.3),
            .init(color: Color(red: 0.88, green: 0.77, blue: 0.37), location: 0.7),
            .init(color: Color(red: 0.7, green: 0.39, blue: 0.22), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient19 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 0.09, green: 0.24, blue: 0.32), location: 0),
            .init(color: Color(red: 0.31, green: 0.31, blue: 0.28), location: 0.3),
            .init(color: Color(red: 0.78, green: 0.46, blue: 0.18), location: 0.6),
            .init(color: Color(red: 0.72, green: 0.29, blue: 0.06), location: 0.8),
            .init(color: Color(red: 0.18, green: 0.07, blue: 0.03), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient20 =  LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 0),
            .init(color: Color(red: 0.09, green: 0.24, blue: 0.32), location: 0.3),
            .init(color: Color(red: 0.54, green: 0.23, blue: 0.07), location: 0.8),
            .init(color: Color(red: 0.14, green: 0.05, blue: 0.01), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient21 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 0.3),
            .init(color: Color(red: 0.349, green: 0.137, blue: 0.043), location: 0.8),
            .init(color: Color(red: 0.184, green: 0.067, blue: 0.027), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient22 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 22/255, green: 27/255, blue: 54/255), location: 0.6),
            .init(color: Color(red: 75/255, green: 29/255, blue: 6/255), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient23 = skyGradient0
}

extension Color {
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
}
