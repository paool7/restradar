//
//  Gradients.swift
//  G2G
//
//  Created by Paul Dippold on 4/11/23.
//

import MapKit
import Solar
import SwiftUI

extension Gradient {
    static func forCurrentTime() -> Gradient? {
        let calendar = Calendar.current
        let currentHour = SettingsAttendant.shared.useTimeGradients ? Int(LocationAttendant.shared.currentHourValue) : Int(SettingsAttendant.shared.gradientHour)
        
        if SettingsAttendant.shared.useTimeGradients, let location = LocationAttendant.shared.current, let solar = Solar(coordinate: location.coordinate), let sunset = solar.sunset, let sunrise = solar.sunrise  {
            let sunsetHour = calendar.component(.hour, from: sunset)
            let sunriseHour = calendar.component(.hour, from: sunrise)
            if sunsetHour == currentHour {
                return Gradient.gradient(forHour: 19)
            } else if sunriseHour == currentHour {
                return Gradient.gradient(forHour: 6)
            } else if currentHour < sunriseHour {
                let difference = sunriseHour - currentHour
                let gradientMapped = 6 - difference
                if gradientMapped >= 0 {
                    return Gradient.gradient(forHour: gradientMapped)
                } else {
                    let wrappedMapped = 24 + gradientMapped
                    return Gradient.gradient(forHour: wrappedMapped)
                }
            } else if currentHour > sunriseHour && currentHour < sunsetHour {
                let difference = sunsetHour - currentHour
                let gradientMapped = 19 - difference
                if gradientMapped >= 6 {
                    return Gradient.gradient(forHour: gradientMapped)
                } else {
                    let wrappedMapped = 24 - gradientMapped
                    return Gradient.gradient(forHour: wrappedMapped)
                }
            } else if currentHour > sunsetHour {
                let difference = currentHour - sunsetHour
                let gradientMapped = 19 + difference
                if gradientMapped <= 23 {
                    return Gradient.gradient(forHour: gradientMapped)
                } else {
                    let wrappedMapped = gradientMapped - 24
                    return Gradient.gradient(forHour: wrappedMapped)
                }
            }
        }
        return Gradient.gradient(forHour: currentHour)
    }
    
    static func gradient(forHour: Int) -> Gradient {
        if forHour < 24 {
            return SettingsAttendant.shared.gradientTheme == .random ? assortedGradients[forHour] : sunriseSunsetGradients[forHour]
        }
        return Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity), Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity)])
    }
    
    static let assortedGradients = [Gradient(colors: [Color(hex: 0xB0DAB9), Color(hex: 0xDAD299)]),
                                    Gradient(colors: [Color(hex: 0xff9472), Color(hex: 0xf2709c)]),
                                    Gradient(colors: [Color(hex: 0x274046), Color(hex: 0xE6DADA)]),
                                    Gradient(colors: [Color(hex: 0xfaaca8), Color(hex: 0xddd6f3)]),
                                    Gradient(colors: [Color(hex: 0x9bc5c3), Color(hex: 0x616161)]),
                                    Gradient(colors: [Color(hex: 0xffc500), Color(hex: 0xc21500)]),
                                    Gradient(colors: [Color(hex: 0xFFB88C), Color(hex: 0xDE6262)]),
                                    Gradient(colors: [Color(hex: 0x182848), Color(hex: 0x4b6cb7)]),
                                    Gradient(colors: [Color(hex: 0x480048), Color(hex: 0xC04848)]),
                                    Gradient(colors: [Color(hex: 0x4389A2), Color(hex: 0x5C258D)]),
                                    Gradient(colors: [Color(hex: 0x71B280), Color(hex: 0x134E5E)]),
                                    Gradient(colors: [Color(hex: 0xFFC837), Color(hex: 0xFF8008)]),
                                    Gradient(colors: [Color(hex: 0xF7BB97), Color(hex: 0xDD5E89)]),
                                    Gradient(colors: [Color(hex: 0xF8CDDA), Color(hex: 0x1D2B64)]),
                                    Gradient(colors: [Color(hex: 0x61045F), Color(hex: 0xAA076B)]),
                                    Gradient(colors: [Color(hex: 0xEDDE5D), Color(hex: 0xF09819)]),
                                    Gradient(colors: [Color(hex: 0xE5E5BE), Color(hex: 0x003973)]),
                                    Gradient(colors: [Color(hex: 0x7AA1D2), Color(hex: 0xDBD4B4), Color(hex: 0xCC95C0)]),
                                    Gradient(colors: [Color(hex: 0xB5AC49), Color(hex: 0x3CA55C)]),
                                    Gradient(colors: [Color(hex: 0x56B4D3), Color(hex: 0x348F50)]),
                                    Gradient(colors: [Color(hex: 0xf7797d), Color(hex: 0xFBD786), Color(hex: 0xC6FFDD)]),
                                    Gradient(colors: [Color(hex: 0x2C5364), Color(hex: 0x203A43), Color(hex: 0x0F2027)]),
                                    Gradient(colors: [Color.white, Color(hex: 0x6DD5FA), Color(hex: 0x2980B9)]),
                                    Gradient(colors: [Color(hex: 0xF27121), Color(hex: 0xE94057), Color(hex: 0x8A2387)])
    ]
    
    static let opacity = 0.7
    
    static let sunriseSunsetGradients = [Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity), Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity)]),
                                         Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity), Color(hex: "20202c")]),
                                         Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255, opacity: opacity), Color(hex: "3a3a52").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "20202c").opacity(opacity), Color(hex: "515175").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "40405c").opacity(opacity), Color(hex: "6f71aa").opacity(opacity), Color(hex: "8a76ab").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "4a4969").opacity(opacity), Color(hex: "7072ab").opacity(opacity), Color(hex: "cd82a0").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "757abf").opacity(opacity), Color(hex: "8583be").opacity(opacity), Color(hex: "eab0d1").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "82addb").opacity(opacity), Color(hex: "ebb2b1").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "94c5f8").opacity(opacity), Color(hex: "a6e6ff").opacity(opacity), Color(hex: "b1b5ea").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "b7eaff").opacity(opacity), Color(hex: "94dfff").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "9be2fe").opacity(opacity), Color(hex: "67d1fb").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "90dffe").opacity(opacity), Color(hex: "38a3d1").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "57c1eb").opacity(opacity), Color(hex: "246fa8").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "2d91c2").opacity(opacity), Color(hex: "1e528e").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "2473ab").opacity(opacity), Color(hex: "1e528e").opacity(opacity), Color(hex: "5b7983").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "1e528e").opacity(opacity), Color(hex: "265889").opacity(opacity), Color(hex: "9da671").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "1e528e").opacity(opacity), Color(hex: "728a7c").opacity(opacity), Color(hex: "e9ce5d").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "154277").opacity(opacity), Color(hex: "576e71").opacity(opacity), Color(hex: "e1c45e").opacity(opacity), Color(hex: "b26339").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "154277").opacity(opacity), Color(hex: "576e71").opacity(opacity), Color(hex: "e1c45e").opacity(opacity), Color(hex: "b26339").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "163C52").opacity(opacity), Color(hex: "4F4F47").opacity(opacity), Color(hex: "C5752D").opacity(opacity), Color(hex: "B7490F").opacity(opacity), Color(hex: "2F1107").opacity(opacity)]),
                                         Gradient(colors: [Color(hex: "163C52").opacity(opacity), Color(hex: "59230B").opacity(opacity), Color(hex: "2F1107").opacity(opacity)]),
                                         Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity), Color(hex: "163C52").opacity(opacity), Color(hex: "59230B").opacity(opacity), Color(hex: "2F1107").opacity(opacity)]),
                                         Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity), Color(hex: "4B1D06").opacity(opacity)]),
                                         Gradient(colors: [Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity), Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity)])]
    
    static var iridescent2: Gradient {
        Gradient(colors: [
            Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.2),
            Color(red: 0.0, green: 0.5, blue: 1.0, opacity: 0.2),
            Color(red: 1.0, green: 0.5, blue: 1.0, opacity: 0.4),
            Color(red: 0.5, green: 1.0, blue: 1.0, opacity: 0.6),
            Color(red: 0.5, green: 1.0, blue: 1.0, opacity: 0.6),
            Color(red: 1.0, green: 0.5, blue: 1.0, opacity: 0.4),
            Color(red: 0.0, green: 0.5, blue: 1.0, opacity: 0.2),
            Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.2),
            Color(red: 22/255, green: 27/255, blue: 54/255).opacity(opacity)
        ])
    }
}

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
}
