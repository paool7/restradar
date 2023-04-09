//
//  CompassView.swift
//  G2G
//
//  Created by Paul Dippold on 3/27/23.
//

import SwiftUI

struct CompassView: View {
    @ObservedObject var attendant = BathroomAttendant.shared
    @Binding var bathroom: Bathroom
        
    var body: some View {
        CompassShapeView(rotation: $bathroom.generalHeading)
//            .rotationEffect(Angle(degrees: bathroom.generalHeading))
//            .animation(Animation.easeIn, value: Angle(degrees: bathroom.generalHeading).animatableData)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .overlay {
                GeometryReader { geometry in
                    ZStack {
                        let height = geometry.size.height
                        let kerning = height/150
                        let textPadding = ((height - (height * 0.8))/2)+4
                        let mapPadding = textPadding
                        let radius = (height-textPadding)/2
                        MapView(bathroom: $bathroom)
                            .clipShape(Circle())
                            .padding(mapPadding)
//                        if height > 0.0 {
//                            if let naturalIntro = bathroom.timeAway, let distanceAway = bathroom.distanceAway {
//                                CircleLabelView(text: naturalIntro + " • " + distanceAway, radius: radius, clockwise: true)
//                                    .font(.subheadline)
//                                    .bold()
//                                    .monospaced()
//                                    .kerning(kerning)
//                                    .foregroundColor(.white)
//                                    .padding(textPadding)
//                                    .rotationEffect(Angle(degrees: bathroom.generalHeading))
//                            }
//                            if let blocksAway = bathroom.totalBlocks, let stepsAway = bathroom.stepsAway {
//                                CircleLabelView(text: blocksAway + " • " + stepsAway, radius: radius, clockwise: false)
//                                    .font(.subheadline)
//                                    .bold()
//                                    .monospaced()
//                                    .kerning(kerning)
//                                    .foregroundColor(.white)
//                                    .padding(textPadding)
//                                    .rotationEffect(Angle(degrees: bathroom.generalHeading))
//                            }
//                        }
                    }
                }
            }
    }
}

struct CompassShapeView: View {
    @ObservedObject var attendant = BathroomAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
    
    static let gradientStart = Color(red: 0.953, green: 0.839, blue: 0.592, opacity: 1.000)
    static let gradientEnd = Color(red: 0.855, green: 0.506, blue: 0.490, opacity: 1.000)
    
    @Binding var rotation: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.height
            let middle = width * 0.5
            
            let arrow = Path { path in
                let topWidth = width * 0.244
                let topHeight = width * 0.183
                path.addLines([
                    CGPoint(x: middle, y: 0),
                    CGPoint(x: middle - topWidth, y: topHeight),
                    CGPoint(x: middle + topWidth, y: topHeight),
                    CGPoint(x: middle, y: 0)
                ])
            }.rotation(Angle(degrees: rotation))
            
            let compass = Path { path in
                path.addArc(center: CGPoint(x: middle, y:middle), radius: width*0.8/2, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
                path.addPath(arrow.path(in: CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height)))
            }.fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.0, y: 0),
                endPoint: UnitPoint(x: 0.75, y: 0.7)))
            
            compass
        }
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassShapeView(rotation: .constant(90))
            .frame(width: 300, height: 300)
        ArrowView()
            .frame(width: 300, height: 300)
    }
}

struct ArrowView: View {
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let middle = width * 0.5
                let topWidth = width * 0.2
                let topHeight = height * 0.14
                
                path.addLines([
                    CGPoint(x: middle, y: 0),
                    CGPoint(x: middle - topWidth, y: topHeight),
                    CGPoint(x: middle-topHeight/2, y: topHeight-5),
                    CGPoint(x: middle-topHeight/2, y: width-15),
                    CGPoint(x: middle+topHeight/2, y: width-15),
                    CGPoint(x: middle+topHeight/2, y: topHeight-5),
                    CGPoint(x: middle + topWidth, y: topHeight),
                    CGPoint(x: middle, y: 0)
                ])
                
                path.addArc(center: CGPoint(x: middle, y:middle), radius: (geometry.size.width/2)*0.8, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
            }
            .fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
    }
}
