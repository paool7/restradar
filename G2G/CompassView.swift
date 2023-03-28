//
//  CompassView.swift
//  G2G
//
//  Created by Paul Dippold on 3/27/23.
//

import SwiftUI

struct CompassView: View {
    var body: some View {
        BadgeSymbol()
            .frame(width: 275, height: 275)
    }
}

struct BadgeSymbol: View {
    static let symbolColor = Color(red: 79.0 / 255, green: 79.0 / 255, blue: 191.0 / 255)
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let spacing = width * 0.01
                let middle = width * 0.5
                let topWidth = width * 0.244
                let topHeight = height * 0.244

                path.addLines([
                    CGPoint(x: middle, y: spacing),
                    CGPoint(x: middle - topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing),
//                    CGPoint(x: middle-15, y: topHeight-20),
//                    CGPoint(x: middle-15, y: width-30),
//                    CGPoint(x: middle+15, y: width-30),
//                    CGPoint(x: middle+15, y: topHeight-20),
                    CGPoint(x: middle + topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: spacing),
                ])
                
                path.addArc(center: CGPoint(x: middle, y:middle), radius: geometry.size.width/2.45, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
            }
            .fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}
