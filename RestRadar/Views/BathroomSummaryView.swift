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
    
    @StateObject var bathroom: Bathroom
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    bathroom.category.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIFont.preferredFont(forTextStyle: .title2).pointSize)
                        .foregroundColor(.primary)
                    Text(bathroom.name)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .minimumScaleFactor(0.75)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                    if bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id }) {
                        VStack(alignment: .leading) {
                            Image(systemName: "bookmark.fill")
                                .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                                .foregroundColor(.primary)
                        }
                    }
                }
                if let current = locationAttendant.current {
                    HStack {
                        VStack(alignment: .center, spacing: 7) {
                            SettingsAttendant.shared.transportMode.image
                                .font(.title3)
                                .foregroundColor(.primary)
                            Text("\(bathroom.totalTime(current: current)) mins")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                            .overlay(.primary)

                        if let distanceString = bathroom.distanceString {
                            VStack(alignment: .leading, spacing: 8) {
                                SettingsAttendant.shared.distanceMeasurement.image
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                Text(distanceString)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Divider()
                            .overlay(.primary)
                        
                        if let currentHeading = locationAttendant.currentHeading {
                            VStack(alignment: .center) {
                                HStack {
                                    Text(" ")
                                        .lineLimit(1)
                                        .font(.title)
                                        .foregroundColor(.primary)
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.title2)
                                        .rotationEffect(Angle(degrees: currentHeading.angle(current.coordinate, bathroom.coordinate)))
                                        .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                                    Text(" ")
                                        .lineLimit(1)
                                        .font(.title)
                                        .foregroundColor(.primary)
                                }
                                Text("direction")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            Divider()
                                .overlay(.primary)
                        }
                        
                        DirectionsSummaryView(bathroom: bathroom)
                        
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                }
                
                if let address = bathroom.address {
                    Divider()
                        .overlay(.primary)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.primary)
                            .font(.callout)
                        Text(address)
                            .lineLimit(2)
                            .font(.subheadline)
                            .truncationMode(.tail)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                    }
                }
            }
//            if let image = bathroom.image {
//                image
//                    .frame(width: 100, height: 100)
//                    .cornerRadius(8)
//            } else {
//                Rectangle()
//                    .frame(width: 100, height: 100)
//                    .cornerRadius(8)
//                    .shiny(.iridescent2)
//            }
        }
        .padding(EdgeInsets(top: 8, leading:12, bottom: 8, trailing: 12))
        .onAppear {
            bathroomAttendant.getImage(bathroom: bathroom)
            bathroom.getDirections()
        }
    }
}

struct BathroomSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomSummaryView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}
