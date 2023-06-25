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
                    .foregroundColor(.primary)
                    .font(.title2)
                    .bold()
                VStack {
                    if let intro = firstStep.naturalCurrentIntro() {
                        Text("\(intro)")
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text(firstStep.instructions)
                        .lineLimit(2)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
