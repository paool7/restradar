//
//  CircleLabel.swift
//  GeometryPractical
//
//  Created by Trung Phan on 3/18/20.
//  Copyright © 2020 TrungPhan. All rights reserved.
//
import Foundation
import SwiftUI

struct CircleLabelView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @StateObject var bathroom: Bathroom
    
    var texts: [(offset: Int, element: Character)] {
        return Array(text.enumerated())
    }
    
    var text: String
    @State var radius: Double
    var clockwise: Bool

    @State var textWidths: [Int:Double] = [:]
    
    var body: some View {
        ZStack {
            ForEach(texts, id: \.offset) { index, letter in
                VStack(alignment: clockwise ? .trailing : .leading, content: {
                    if !clockwise {
                        Spacer()
                    }
                    Text(String(letter))
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { width in
                            textWidths[index] = width
                        })
                    if clockwise {
                        Spacer()
                    }
                })
                .rotationEffect(clockwise ? angle(at: index) : -angle(at: index))
            }
        }
        .rotationEffect(clockwise ? -angle(at: texts.count-1)/2 : angle(at: texts.count-1)/2)
        .shadow(radius: 4)
    }
    
    func angle(at index: Int) -> Angle {
        guard let labelWidth = textWidths[index] else { return .radians(0) }

        let circumference = radius * 2 * .pi

        let percent = labelWidth / circumference
        let labelAngle = percent * 2 * .pi

        let widthBeforeLabel = textWidths.filter{$0.key < index}.map{$0.value}.reduce(0, +)
        let percentBeforeLabel = widthBeforeLabel / circumference
        let angleBeforeLabel = percentBeforeLabel * 2 * .pi
        return .radians(angleBeforeLabel + labelAngle)
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

struct CircleLabelView_Previews: PreviewProvider {
    static var previews: some View {
        CircleLabelView(bathroom: BathroomAttendant.shared.closestBathroom, text: "Latitude 35.08587 E • Longitude 21.43673 W".uppercased(), radius: 275/2, clockwise: true)
            .font(.system(size: 13, design: .monospaced)).bold()
            .frame(width: 275, height: 275)
        CircleLabelView(bathroom: BathroomAttendant.shared.closestBathroom, text: "Latitude 35.08587 E • Longitude 21.43673 W • Elevation 64M • Incline 12".uppercased(), radius: 275/2, clockwise: false)
            .font(.system(size: 13, design: .monospaced)).bold()
            .frame(width: 275, height: 275)
        
    }
}
