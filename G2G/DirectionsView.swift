//
//  DirectionsView.swift
//  G2G
//
//  Created by Paul Dippold on 3/29/23.
//

import SwiftUI
import MapKit

struct DirectionsView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @Binding var bathroom: Bathroom
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mappin")
                    .font(.title3)
                Text(bathroom.address)
                    .font(.title3)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity)
            VStack(alignment: .center) {
                CompassView(bathroom: $bathroom)
                    .frame(height: 325)
                if let nextStep = bathroom.currentRouteStep(), let intro = nextStep.naturalCurrentIntro() {
                    HStack {
                        Text("\(intro)")
                            .font(.title2)
                            .bold()
                        Image(systemName: bathroom.imageFor(step: nextStep))
                            .font(.title2)
                            .bold()
                    }
                }
            }
            Divider()
                .overlay(.primary)
                if !bathroom.directions.isEmpty {
                    ForEach(bathroom.directions, id: \.hash) { step in
                        if let naturalInstructions = step.naturalInstructions, let index = bathroom.indexFor(step: step), index >= bathroom.currentRouteStepIndex ?? index {
                            HStack {
                                Image(systemName: bathroom.imageFor(step: step))
                                    .font(step == bathroom.currentRouteStep() ? .title2 : .title3)
                                    .if(step == bathroom.currentRouteStep()) {$0.bold() }
                                    .foregroundColor(.primary)
                                Text(step == bathroom.currentRouteStep() ? step.instructions : naturalInstructions)
                                    .font(step == bathroom.currentRouteStep() ? .title2 : .title3)
                                    .if(step == bathroom.currentRouteStep()) { $0.bold() }
                                    .lineLimit(3)
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: step == bathroom.directions.last ? 0 : 4, trailing: 0))
                        }
                    }
                } else {
                    ProgressView()
                    Spacer()
                        .frame(maxHeight: .infinity)
                }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background {
            Color(uiColor: .secondarySystemBackground)
                .cornerRadius(16)
        }
        .onAppear {
            if bathroom.directions.isEmpty {
                locationAttendant.getDirections(to: bathroom.id)
            }
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView(bathroom: .constant(BathroomAttendant().closestBathroom))
    }
}
