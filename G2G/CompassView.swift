//
//  CompassView.swift
//  G2G
//
//  Created by Paul Dippold on 3/27/23.
//

import SwiftUI

struct CompassView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @Binding var bathroom: Bathroom
    
    @State var current = LocationAttendant.shared.current
    @State var currentHeading = LocationAttendant.shared.currentHeading

    var body: some View {
            CompassShapeView(rotation: $bathroom.generalHeading)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .overlay {
                    GeometryReader { geometry in
                        ZStack {
                            let height = geometry.size.height
                            let kerning = height/150
                            let textPadding = ((height - (height * 0.8))/2)+4
                            let mapPadding = textPadding+UIFont.preferredFont(forTextStyle: .subheadline).pointSize+8
                            let radius = (height-textPadding)/2
                            let normalizedRadius = radius > 150.0 ? radius : 150.0
                            MapView(bathroom: $bathroom)
                                .clipShape(Circle())
                                .padding(mapPadding)
                            if radius > 100.0 {
                                if let current = current, let timeAway = bathroom.timeAway(current: current), let stepsAway = bathroom.stepsAway(current: current) {
                                    CircleLabelView(bathroom: $bathroom, text: timeAway + " • " + stepsAway, radius: normalizedRadius, clockwise: true)
                                        .font(.subheadline)
                                        .bold()
                                        .monospaced()
                                        .kerning(kerning)
                                        .foregroundColor(.white)
                                        .padding(textPadding)
                                }
                                if let current = locationAttendant.current, let blocksAway = bathroom.totalBlocks, let distanceAway = bathroom.distanceAway(current: current) {
                                    CircleLabelView(bathroom: $bathroom, text: blocksAway + " • " + distanceAway, radius: normalizedRadius, clockwise: false)
                                        .font(.subheadline)
                                        .bold()
                                        .monospaced()
                                        .kerning(kerning)
                                        .foregroundColor(.white)
                                        .padding(textPadding)
                                }
                            }
                        }
                    }
                }
    }
}

struct CompassShapeView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @State var current = LocationAttendant.shared.current
    @State var currentHeading = LocationAttendant.shared.currentHeading

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
            }.fill(locationAttendant.gradientForCurrentTime() ?? .linearGradient(colors: [.secondary], startPoint: .top, endPoint: .bottom))

            
            compass
        }
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassShapeView(rotation: .constant(90))
            .frame(width: 300, height: 300)
    }
}


