//
//  FavoritesView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var attendant = BathroomAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
                VStack(alignment: .leading, spacing: -6, content: {
                    Text("Favorite Bathrooms:")
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                    List($attendant.favoriteBathrooms) { $bathroom in
                        NavigationLink(destination: BathroomView(bathroom: $bathroom)) {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack{
                                    Text(bathroom.name)
                                        .font(.headline)
                                    Image(systemName: "arrow.up.circle")
                                        .rotationEffect(.degrees(bathroom.generalHeading))
                                    Spacer()
                                }
                                if let distanceAway = bathroom.distanceAway, let timeAway = bathroom.timeAway {
                                    HStack {
                                        Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
                                        Text("\(timeAway) • \(distanceAway)")
                                            .font(.callout)
                                    }
                                }
                                if let code = bathroom.code {
                                    HStack{
                                        Image(systemName: "lock.shield")
                                        Text("Code: \(code)")
                                            .font(.callout)
                                    }
                                }
                                if let comment = bathroom.comment {
                                    HStack{
                                        Image(systemName: "exclamationmark.bubble")
                                        Text(comment)
                                            .font(.callout)
                                    }
                                }
                            }
                        }
                    }
                    .cornerRadius(16)
                    .listStyle(.plain)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                })
                .foregroundColor(.white)
        }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
