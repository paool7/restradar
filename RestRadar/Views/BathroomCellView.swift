//
//  BathroomCellView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI
import Shiny

struct BathroomCellView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @Binding var bathroom: Bathroom
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(bathroom.name)
                    .font(.headline)
                if let current = locationAttendant.current {
                    Image(systemName: "arrow.up.circle")
                        .rotationEffect(.degrees(locationAttendant.currentHeading.angle(current.coordinate, bathroom.coordinate)))
                }
                Spacer()
                if bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id }) {
                    Image(systemName: "bookmark.fill")
                        .shiny(.iridescent2)
                }
            }
            CompactStatsView(bathroom: $bathroom)
                .frame(height: UIFont.preferredFont(forTextStyle: .headline).pointSize)
        }
    }
}

struct BathroomCellView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomCellView(bathroom: .constant(BathroomAttendant().closestBathroom))
    }
}