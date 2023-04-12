//
//  BathroomCellView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI

struct BathroomCellView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @Binding var bathroom: Bathroom
    
    var body: some View {
        NavigationLink(destination: BathroomView(bathroom: $bathroom)) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(bathroom.name)
                        .font(.headline)
                    Image(systemName: "arrow.up.circle")
                        .rotationEffect(.degrees(bathroom.generalHeading))
                    Spacer()
                    if bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id }) {
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(.yellow)
                    }
                }
                if let current = locationAttendant.current, let distanceAway = bathroom.distanceAway(current: current), let timeAway = bathroom.timeAway(current: current) {
                    HStack {
                        Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
                        Text("\(timeAway) • \(distanceAway)")
                            .font(.callout)
                    }
                }
                if let code = bathroom.code {
                    HStack {
                        Image(systemName: "lock.shield")
                        Text("Code: \(code)")
                            .font(.callout)
                    }
                }
                if let comment = bathroom.comment {
                    HStack {
                        Image(systemName: "exclamationmark.bubble")
                        Text(comment)
                            .font(.callout)
                    }
                }
            }
        }
    }
}

struct BathroomCellView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomCellView(bathroom: .constant(BathroomAttendant().closestBathroom))
    }
}
