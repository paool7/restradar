//
//  DirectionsSummaryView.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/9/23.
//

import SwiftUI

struct DirectionsSummaryView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @StateObject var bathroom: Bathroom
    
    var body: some View {
        if bathroom.directions.count > 0 {
            HStack {
                let currentIndex = bathroom.currentRouteStepIndex
                let firstStep = bathroom.directions[currentIndex]
                let firstImage = bathroom.imageFor(step: firstStep)
                
                Image(systemName: firstImage)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                if let intro = firstStep.naturalSummaryIntro() {
                    Text("\(intro)")
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}
