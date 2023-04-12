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
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showLocation = false
    @State private var showSettings = false
    
    @State var current = LocationAttendant.shared.current
    @State var currentHeading = LocationAttendant.shared.currentHeading

    var body: some View {
            VStack {
                List($bathroomAttendant.filteredBathrooms) { bathroom in
                    if (bathroom.id == bathroomAttendant.filteredBathrooms.first?.id) {
                        NavigationLink(destination: BathroomView(bathroom: bathroom)) {
                            HeaderView(bathroom: bathroom, moreDetail: false)
                        }
                    } else {
                        BathroomCellView(bathroom: bathroom)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("g2g?")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Text("Filter:")
                        .font(.callout)
                    Button {
                        bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
                    } label: {
                        Image(systemName: bathroomAttendant.onlyFavorites ? "bookmark.fill" : "bookmark")
                            .foregroundColor(bathroomAttendant.onlyFavorites ? .yellow : .primary)
                    }
                    
                    Button {
                        self.showLocation = !self.showLocation
                    } label: {
                        Image(systemName: "location.magnifyingglass")
                            .foregroundColor(locationAttendant.selectedSearchLocation != nil ? .mint : .primary)
                    }
                    .popover(isPresented: $showLocation, attachmentAnchor: .point(.trailing), arrowEdge: .top) {
                        LocationSearchView(locationService: locationAttendant.locationService)
                    }
                    
                    Button {
                        if bathroomAttendant.noCodes == nil {
                            bathroomAttendant.noCodes = true
                        } else if bathroomAttendant.noCodes == true {
                            bathroomAttendant.noCodes = false
                        } else if bathroomAttendant.noCodes == false {
                            bathroomAttendant.noCodes = nil
                        }
                    } label: {
                        Image(systemName: bathroomAttendant.noCodes == true ? "lock.open" : (bathroomAttendant.noCodes == nil ? "lock.shield" : "lock"))
                            .foregroundColor(bathroomAttendant.noCodes == true ? .mint : (bathroomAttendant.noCodes == nil ? .primary : .red))
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        self.showSettings = true
                    } label: {
                        Image(systemName: "gear")
                        
                    }
                    
                }
            }
            .foregroundColor(.primary)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    locationAttendant.requestAuthorization()
                } else if newPhase == .background {
                    locationAttendant.stopUpdating()
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
