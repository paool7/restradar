//
//  HeaderView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import SwiftUI
import MapKit

struct HeaderView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @Binding var bathroom: Bathroom
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(bathroom.name)
                    .font(.title)
                    .bold()
                Spacer()
                if bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id }) {
                    Image(systemName: "bookmark.fill")
                        .shiny(.iridescent)
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    CompactStatsView(bathroom: $bathroom)
                        .frame(height: UIFont.preferredFont(forTextStyle: .headline).pointSize)
                    
                    if let comment = bathroom.comment {
                        Text("\(Image(systemName: "exclamationmark.bubble")) \(comment)")
                            .font(.title2)
                            .bold()
                    }
                    
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
                    
                    Spacer()
                }
                
                CompassView(bathroom: $bathroom)
                .aspectRatio(contentMode: .fill)
            }
        }
        .padding(8)
        .foregroundColor(.primary)
        .frame(maxHeight: .infinity)
        .onAppear {
            if bathroom.directions.isEmpty {
                locationAttendant.getDirections(to: bathroom.id)
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(bathroom: .constant(BathroomAttendant().closestBathroom))
    }
}
