//
//  ContentView.swift
//  G2G
//
//  Created by Paul Dippold on 3/5/23.
//

import SwiftUI
import MapKit
import CoreLocation
import Foundation

struct ContentView: View {
    @ObservedObject var attendant = BathroomAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
    @Environment(\.scenePhase) var scenePhase
        
    
    @State var closestBathroom = BathroomAttendant.shared.defaults.first
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center, spacing: -12, content: {
                    Text("G2G? Try:")
                        .font(.title)
                        .bold()
                    if let current = LocationAttendant.shared.current, let id = closestBathroom?.id {
                        Button {} label: {
                            NavigationLink(destination: BathroomView(id: id)) {
                                HeaderView(id: id)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(16)
                    }
                })
                
                Divider()
                
                VStack(alignment: .leading, spacing: -6, content: {
                    Text("Next Closest Bathrooms:")
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .font(.subheadline)
                        .bold()
                    List($attendant.defaults) { $bathroom in
                        NavigationLink(destination: BathroomView(id: bathroom.id)) {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack{
                                    Text(bathroom.name)
                                        .font(.headline)
                                    Image(systemName: "arrow.up.circle")
                                        .rotationEffect(.degrees(bathroom.heading))
                                }
                                if let distanceAway = bathroom.distanceAway {
                                    HStack {
                                        Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
                                        Text(distanceAway)
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
                            .listRowBackground(Color(uiColor: .secondarySystemBackground))
                        }
                    }
                    .cornerRadius(16)
                    .listStyle(.plain)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                })
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    LocationAttendant.shared.requestAuthorization()
                } else if newPhase == .background {
                    LocationAttendant.shared.stopUpdating()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
