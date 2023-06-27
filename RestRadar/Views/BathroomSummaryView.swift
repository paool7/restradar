//
//  BathroomSummaryView.swift
//  G2G
//
//  Created by Paul Dippold on 4/24/23.
//

import MapKit
import SwiftUI
import Shiny

struct BathroomSummaryView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @StateObject var bathroom: Bathroom
    @State var scene: MKLookAroundScene?
    @State var isLoadingScene = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(bathroom.category.backgroundColor)
                    .overlay {
                        bathroom.category.image
                            .font(.title3)
                            .foregroundColor(bathroom.category.backgroundColor.accessibleFontColor)
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(height: UIFont.preferredFont(forTextStyle: .title2).pointSize * 2 )
                
                Text(bathroom.name)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                                        
                HStack {
                    Divider()
                        .overlay(.primary)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Image(systemName: "hourglass")
                            .font(.title2)
                            .monospacedDigit()
                            .foregroundColor(.primary)
                        Text("\(bathroom.totalTime() ?? 0) mins")
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                            .scaledToFill()
                    }
                    
                    Divider()
                        .overlay(.primary)

                    if let distanceString = bathroom.distanceString(withUnit: true) {
                        VStack(alignment: .center, spacing: 10) {
                            SettingsAttendant.shared.distanceMeasurement.image
                                .font(.title3)
                                .foregroundColor(.primary)
                            Text(distanceString)
                                .font(.caption)
                                .lineLimit(1)
                                .monospacedDigit()
                                .foregroundColor(.primary)
                                .scaledToFill()
                        }
                    }
                    
                    Divider()
                        .overlay(.primary)
                    
                    if let currentHeading = locationAttendant.currentHeading, let current = locationAttendant.current {
                        VStack(alignment: .center, spacing: 10) {
                            Image(systemName: "arrow.up.to.line.circle")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .rotationEffect(Angle(degrees: current.coordinate.angle(bathroom.coordinate, offset: currentHeading)))
                            Text("direction")
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .scaledToFill()
                        }
                    }
                }
            }
            
            Divider()
                .overlay(.primary)
            
            HStack {
                if let address = bathroom.address {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.primary)
                            .font(.callout)
                        Text(address)
                            .lineLimit(1)
                            .font(.subheadline)
                            .truncationMode(.tail)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                if bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id }) {
                    VStack(alignment: .leading) {
                        Image(systemName: "bookmark.fill")
                            .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                            .shadow(color: .primary, radius: 0.5)
                    }
                }
            }
        }
        .padding(8)
    }
}

