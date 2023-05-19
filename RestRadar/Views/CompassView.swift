//
//  CompassView.swift
//  G2G
//
//  Created by Paul Dippold on 3/27/23.
//

import SwiftUI
import Shiny

struct CompassView: View {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared
    
    @Binding var bathroom: Bathroom
    
    var body: some View {
        if let current = locationAttendant.current {
            CompassShapeView(rotation: locationAttendant.currentHeading.angle(current.coordinate, bathroom.coordinate))
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .overlay {
                    GeometryReader { geometry in
                        ZStack {
                            let height = geometry.size.height
                            let padding = height * 0.15
                            MapView(bathroom: $bathroom)
                                .clipShape(Circle())
                                .padding(padding)
                        }
                    }
                }
                .shadow(color: .primary.opacity(0.5), radius: 1)
                .onAppear {
                    if bathroom.directions.isEmpty {
                        bathroom.getDirections()
                    }
                }
        }
    }
}

struct CompassShapeView: View {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared

    static let gradientStart = Color(red: 0.953, green: 0.839, blue: 0.592, opacity: 1.000)
    static let gradientEnd = Color(red: 0.855, green: 0.506, blue: 0.490, opacity: 1.000)
    
    var rotation: Double
    
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
            }.fill(.linearGradient(Gradient.forCurrentTime() ?? Gradient(colors:  [.secondary]), startPoint: .top, endPoint: .bottom))
            
            compass
        }
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassShapeView(rotation: 90)
            .shadow(radius: 4)
            .frame(width: 300, height: 300)
    }
}


