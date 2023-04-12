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
    static let skyGradient0 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(uiColor: UIColor.secondarySystemBackground), location: 0),
            .init(color: Color(uiColor: UIColor.secondarySystemBackground), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient1 = skyGradient0
    
    static let skyGradient2 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(uiColor: UIColor.secondarySystemBackground), location: 0.5),
            .init(color: Color(red: 58/255, green: 58/255, blue: 82/255), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient3 = LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(uiColor: UIColor.secondarySystemBackground), location: 0.1), Gradient.Stop(color: Color(red: 58/255, green: 58/255, blue: 82/255), location: 1)]), startPoint: .top, endPoint: .bottom)
    
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
            .init(color: Color(red: 0.03, green: 0.11, blue: 0.15), location: 0),
            .init(color: Color(red: 0.03, green: 0.11, blue: 0.15), location: 0.3),
            .init(color: Color(red: 0.54, green: 0.23, blue: 0.07), location: 0.8),
            .init(color: Color(red: 0.14, green: 0.05, blue: 0.01), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient21 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(uiColor: UIColor.secondarySystemBackground), location: 0.3),
            .init(color: Color(red: 0.349, green: 0.137, blue: 0.043), location: 0.8),
            .init(color: Color(red: 0.184, green: 0.067, blue: 0.027), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient22 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(uiColor: UIColor.secondarySystemBackground), location: 0.5),
            .init(color: Color(red: 75/255, green: 29/255, blue: 6/255), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let skyGradient23 = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(uiColor: UIColor.secondarySystemBackground), location: 0),
            .init(color: Color(uiColor: UIColor.secondarySystemBackground), location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
