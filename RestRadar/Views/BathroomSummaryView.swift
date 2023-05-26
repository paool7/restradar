//
//  BathroomSummaryView.swift
//  G2G
//
//  Created by Paul Dippold on 4/24/23.
//

import SwiftUI
import Shiny

struct BathroomSummaryView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @Binding var bathroom: Bathroom
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                    Text(bathroom.name)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .minimumScaleFactor(0.75)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                if let current = locationAttendant.current, let timeAway = bathroom.totalTime(current: current) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(timeAway)")
                                    .lineLimit(1)
                                    .font(.title)
                                    .foregroundColor(.primary)
                                Image(systemName: "hourglass")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                            Text("mins")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        if let totalBlocks = bathroom.totalBlocks, totalBlocks > 0 {
                            Divider()
                                .overlay(.primary)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(totalBlocks)")
                                        .lineLimit(1)
                                        .font(.title)
                                        .foregroundColor(.primary)
                                    Image(systemName: "building.2")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }
                                Text("blocks")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        } else if let distance = bathroom.distance(current: current) {
                            Divider()
                                .overlay(.primary)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(String(format: "%.1f", distance))
                                        .lineLimit(1)
                                        .font(.title)
                                        .foregroundColor(.primary)
                                    Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }
                                Text("miles")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                        if self.bathroom.id != bathroomAttendant.filteredBathrooms.first?.id {
                            if let code = bathroom.code {
                                Divider()
                                    .overlay(.primary)
                                HStack {
                                    Image(systemName: "lock.shield")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(code)
                                        .lineLimit(2)
                                        .font(.title3)
                                        .bold()
                                        .minimumScaleFactor(0.2)
                                        .foregroundColor(.primary)
                                }
                            } else {
                                Divider()
                                    .overlay(.primary)
                                VStack(alignment: .leading) {
                                    Image(systemName: "lock.open")
                                        .font(.title3)
                                        .bold()
                                    Text("unlocked")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        if bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id }) {
                            Divider()
                                .overlay(.primary)
                            VStack(alignment: .leading) {
                                Image(systemName: "bookmark.fill")
                                    .shiny(.iridescent2)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                }
                
                if let directions = bathroom.directions, directions.count > 0, self.bathroom.id == bathroomAttendant.filteredBathrooms.first?.id {
                    Divider()
                        .overlay(.primary)
                    HStack {
                        Spacer()
                        let currentIndex = bathroom.currentRouteStepIndex

                        if let firstStep = bathroom.directions[currentIndex], let firstImage = bathroom.imageFor(step: firstStep), firstImage != "figure.walk" {
                            Image(systemName: "figure.walk")
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.5)
                                .font(.title2)
                                .bold()
                        }
                        ForEach(directions, id: \.hash) { step in
                            if directions.firstIndex(of: step) ?? currentIndex >= currentIndex {
                                Image(systemName: bathroom.imageFor(step: step))
                                    .foregroundColor(.primary)
                                    .minimumScaleFactor(0.5)
                                    .if(step == bathroom.currentRouteStep()) { $0.bold() }
                                    .font(step == bathroom.currentRouteStep() ? .title : .title2)
                            }
                        }
                        Spacer()
                    }.scaledToFit()
                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))

                }
                if let comment = bathroom.comment {
                    Divider()
                        .overlay(.primary)
                    Text(comment)
                        .lineLimit(2)
                        .font(.subheadline)
                        .truncationMode(.tail)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                }
            }
            if bathroom.id == bathroomAttendant.closestBathroom.id {
                CompassView(bathroom: $bathroom)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .padding(EdgeInsets(top: 8, leading:12, bottom: 8, trailing: 12))
    }
}

struct BathroomSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomSummaryView(bathroom: .constant(BathroomAttendant.shared.closestBathroom))
    }
}
