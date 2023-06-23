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
                
                if firstImage != "figure.walk.departure" {
                    VStack {
                        Image(systemName: "figure.walk.departure")
                            .foregroundColor(.primary)
                            .font(.title2)
                            .bold()
                            .frame(height: UIFont.preferredFont(forTextStyle: .title2).pointSize)
                        Text(SettingsAttendant.shared.transportMode.verb)
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .frame(height: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
                            
                    }
                }
                ForEach(bathroom.directions, id: \.hash) { step in
                    let stepIndex = bathroom.directions.firstIndex(of: step) ?? currentIndex
                    if (stepIndex >= currentIndex) && ((stepIndex - currentIndex) < 3)  {
                        VStack(alignment: .center) {
                            Image(systemName: bathroom.imageFor(step: step))
                                .foregroundColor(.primary)
                                .font(.title2)
                                .frame(height: UIFont.preferredFont(forTextStyle: .title2).pointSize)
                            Text(bathroom.summaryFor(step: step))
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .frame(height: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
                        }
                    }
                }
            }.scaledToFill()
        }
    }
}
