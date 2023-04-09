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
    
    @State private var showFavorites = false
    @State private var showSettings = false

    var body: some View {
            VStack {
                VStack(alignment: .center, spacing: -12, content: {
                    if showFavorites {
                        NavigationLink(destination: BathroomView(bathroom: $attendant.closestBathroom)) {
                            HeaderView(bathroom: $attendant.closestBathroom)
                                .foregroundColor(.primary)
                                .padding(16)
                        }
                    } else if let bathroom = $attendant.favoriteBathrooms.first {
                        NavigationLink(destination: BathroomView(bathroom: bathroom)) {
                            HeaderView(bathroom: bathroom)
                                .foregroundColor(.primary)
                                .padding(16)
                        }
                    }
                })
                
                Divider()
                
                VStack(alignment: .leading, spacing: -6, content: {
                    Text("Closest Bathrooms:")
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .font(.subheadline)
                        .bold()
                    if showFavorites {
                        List($attendant.favoriteBathrooms) { bathroom in
                            BathroomCellView(bathroom: bathroom)
                        }
                        .cornerRadius(16)
                        .listStyle(.plain)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    } else {
                        List($attendant.sortedBathrooms) { bathroom in
                            BathroomCellView(bathroom: bathroom)
                        }
                        .cornerRadius(16)
                        .listStyle(.plain)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.showFavorites = !self.showFavorites
                    } label: {
                        Image(systemName: self.showFavorites ? "bookmark.fill" : "bookmark")
                            .foregroundColor(self.showFavorites ? .yellow : .white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showSettings = true
                    } label: {
                        Image(systemName: "gear")
                        
                    }
                }
            }
            .foregroundColor(.white)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    LocationAttendant.shared.requestAuthorization()
                } else if newPhase == .background {
                    LocationAttendant.shared.stopUpdating()
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
