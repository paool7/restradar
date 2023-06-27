//
//  DirectionsView.swift
//  G2G
//
//  Created by Paul Dippold on 3/29/23.
//

import Karte
import MapKit
import SwiftUI
import TelemetryClient

struct DirectionsView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @StateObject var bathroom: Bathroom
    
    var body: some View {
        VStack {
            Divider()
                .overlay(.primary)
            HStack {
                if let totalTime = bathroom.totalTime() {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(totalTime)")
                                .font(.title)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.primary)
                            Image(systemName: "hourglass")
                                .font(.title3)
                        }
                        Text("mins")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }.fixedSize(horizontal: true, vertical: true)
                    Spacer()
                }
                
                Divider()
                    .overlay(.primary)
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        if let distanceString = bathroom.distanceString(withUnit: false) {
                            Text(distanceString)
                                .lineLimit(1)
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                        
                        SettingsAttendant.shared.distanceMeasurement.image
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    Text(SettingsAttendant.shared.distanceMeasurement.name.lowercased())
                        .font(.caption)
                        .foregroundColor(.primary)
                }.fixedSize(horizontal: true, vertical: true)
                Spacer()
                
                if let current = locationAttendant.current {
                    Divider()
                        .overlay(.primary)
                    Spacer()
                    VStack(alignment: .center) {
                        HStack {
                            Text(current.coordinate.angle(bathroom.coordinate).compassRepresentation)
                                .font(.title)
                                .foregroundColor(.primary)
                            Image(systemName: "location.north.line")
                                .font(.title3)
                                .rotationEffect(Angle(degrees: current.coordinate.angle(bathroom.coordinate)))
                        }
                        Text("direction")
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .scaledToFill()
                    }.fixedSize(horizontal: true, vertical: true)
                    Spacer()
                }
            }
            .frame(height: 50)
            
            Divider()
                .overlay(.primary)

            if !bathroom.directions.isEmpty {
                ForEach(bathroom.directions, id: \.hash) { step in
                    if let naturalInstructions = step.naturalInstructions, let index = bathroom.indexFor(step: step), index >= bathroom.currentRouteStepIndex {
                        HStack {
                            Image(systemName: bathroom.imageFor(step: step))
                                .font(step == bathroom.currentRouteStep() ? .title2 : .title3)
                                .if(step == bathroom.currentRouteStep()) {$0.bold() }
                                .foregroundColor(.primary)
                            
                            let intro = step == bathroom.currentRouteStep() ? step.naturalCurrentIntro() ?? "" : ""
                            Text(intro + (step == bathroom.currentRouteStep() ? step.instructions : naturalInstructions))
                                .font(step == bathroom.currentRouteStep() ? .title2 : .title3)
                                .if(step == bathroom.currentRouteStep()) { $0.bold() }
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
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
        .frame(maxWidth: .infinity)
        .onAppear {
            bathroom.getDirections()
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView(bathroom: BathroomAttendant().closestBathroom)
    }
}
