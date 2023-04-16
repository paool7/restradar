//
//  BathroomView.swift
//  G2G
//
//  Created by Paul Dippold on 3/19/23.
//

import SwiftUI
import MapKit
import Shiny

struct BathroomView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @Binding var bathroom: Bathroom
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(bathroom.name)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Spacer()
                }
                
                VStack(alignment: .center, spacing: 8) {
                    if let totalBlocks = bathroom.totalBlocks, let current = locationAttendant.current, let timeAway = bathroom.totalTime(current: current) {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                HStack {
                                    Text("\(timeAway)")
                                        .font(.largeTitle)
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
                            
                            Divider()
                                .overlay(.primary)
                            
                            Spacer()
                            VStack(alignment: .center) {
                                HStack(alignment:.center) {
                                    Text("\(totalBlocks)")
                                        .font(.largeTitle)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.primary)
                                    Image(systemName: "building.2")
                                        .font(.title3)
                                }
                                Text("blocks")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }.fixedSize(horizontal: true, vertical: true)
                            Spacer()
                            
                            if let code = bathroom.code {
                                Divider()
                                    .overlay(.primary)
                                Spacer()
                                VStack(alignment: .center) {
                                    HStack(alignment:.center) {
                                        Text("\(code)")
                                            .font(.largeTitle)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.primary)
                                        Image(systemName: "lock.shield")
                                            .font(.title3)
                                    }
                                    Text("code")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }.fixedSize(horizontal: true, vertical: true)
                                Spacer()
                            } else {
                                Divider()
                                    .overlay(.primary)
                                Spacer()
                                VStack(alignment: .center) {
                                    Image(systemName: "lock.open")
                                        .font(.title3)
                                        .bold()
                                        .frame(alignment: .center)
                                        .frame(height: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
                                    Text("unlocked")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }.fixedSize(horizontal: true, vertical: true)
                                Spacer()
                            }
                        }
                        .frame(height: 50)
                    }
                    if let comment = bathroom.comment {
                        Divider()
                            .overlay(.primary)
                        Text("\(comment)")
                            .font(.title3)
                            .frame(alignment: .center)
                    }
                }
                .padding(8)
                .background {
                    Color(uiColor: .secondarySystemBackground)
                        .cornerRadius(16)
                }
                
                DirectionsView(bathroom: $bathroom)
            }
            .padding(8)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                
                Button {
                    if let index = bathroomAttendant.favoriteBathrooms.firstIndex(where: { $0.id == bathroom.id }) {
                        bathroomAttendant.favoriteBathrooms.remove(at: index)
                    } else {
                        bathroomAttendant.favoriteBathrooms.append(bathroom)
                    }
                } label: {
                    Image(systemName: bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id })  ? "bookmark.fill" : "bookmark")
                        .if(bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id })) { $0.shiny(Gradient.forCurrentTime() ?? .iridescent) }
                        .foregroundColor(.primary)
                }
                
            }
        }
    }
}

struct BathroomView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomView(bathroom: .constant(BathroomAttendant.shared.closestBathroom))
    }
}
