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
    
    @StateObject var bathroom: Bathroom
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Button {
                    let coordinate = CLLocationCoordinate2DMake(bathroom.coordinate.latitude, bathroom.coordinate.longitude)
                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
                    mapItem.name = self.bathroom.name
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
                } label: {
                    CompassView(bathroom: bathroom)
                        .frame(height: 325)
                }
            }
            Spacer()
            if let current = locationAttendant.current, let stepsAway = bathroom.stepsAway(current: current) {
                Text(stepsAway)
                    .font(.title3)
                    .minimumScaleFactor(0.75)
            }
            Divider()
                .overlay(.primary)
            if let nextStep = bathroom.currentRouteStep(), let intro = nextStep.naturalCurrentIntro() {
                HStack {
                    Text("\(intro)")
                        .font(.title2)
                        .bold()
                }
                Spacer()
            }
            if !bathroom.directions.isEmpty {
                ForEach(bathroom.directions, id: \.hash) { step in
                    if let naturalInstructions = step.naturalInstructions, let index = bathroom.indexFor(step: step), index >= bathroom.currentRouteStepIndex {
                        HStack {
                            Image(systemName: bathroom.imageFor(step: step))
                                .font(step == bathroom.currentRouteStep() ? .title2 : .title3)
                                .if(step == bathroom.currentRouteStep()) {$0.bold() }
                                .foregroundColor(.primary)
                            Text(step == bathroom.currentRouteStep() ? step.instructions : naturalInstructions)
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
        .padding(8)
        .frame(maxWidth: .infinity)
        .background {
            Color(uiColor: .secondarySystemBackground)
                .cornerRadius(16)
        }
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
