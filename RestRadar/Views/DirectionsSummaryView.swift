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
                
                if firstImage != "figure.walk" {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.primary)
//                        .minimumScaleFactor(0.5)
                        .font(.title2)
                        .bold()
                }
                ForEach(bathroom.directions, id: \.hash) { step in
                    let stepIndex = bathroom.directions.firstIndex(of: step) ?? currentIndex
                    if (stepIndex >= currentIndex) && ((stepIndex - currentIndex) < 4)  {
                        Image(systemName: bathroom.imageFor(step: step))
                            .foregroundColor(.primary)
                            .font(.title2)
//                            .minimumScaleFactor(0.5)
//                            .if(step == bathroom.currentRouteStep()) { $0.bold() }
//                            .font(step == bathroom.currentRouteStep() ? .title : .title2)
                    }
                }
            }.scaledToFit()
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
        }
    }
}

struct DirectionsSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsSummaryView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}
