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
    @State var id: Int
    
    let actionImage = SettingsAttendant.shared.transportMode == .walking ? "figure.walk" : "figure.roll"
    let startImage = "circle.fill"
    let endImage = "octagon.fill"
    
    let transitActionImage = "tram"

    var body: some View {
            ScrollView {
                if !bathroom.directions.isEmpty {
                    ForEach(bathroom.directions, id: \.hash) { direction in
                        if let naturalInstructions = direction.naturalInstructions {
                            HStack {
                                Text(Image(systemName: direction == bathroom.directions.first ? startImage : (direction == bathroom.directions.last ? endImage : actionImage)))
                                    .foregroundColor(direction == bathroom.directions.first ? .green : (direction == bathroom.directions.last ? .red : .primary))
                                Text(naturalInstructions)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
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
                    locationAttendant.getDirections(to: id)
                }
            }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView(bathroom: .constant(BathroomAttendant().closestBathroom), id: BathroomAttendant().closestBathroom.id)
    }
}
