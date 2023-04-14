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
    @StateObject private var eventAttendant = EventsRepository.shared

    @Environment(\.scenePhase) var scenePhase
    
    @State private var showLocation = false
    @State private var showSettings = false
    @State private var showBathroom = false
    @State var selectedBathroom: Int?

    var body: some View {
            VStack {
                List($bathroomAttendant.filteredBathrooms) { bathroom in
                    NavigationLink(destination: BathroomView(bathroom: bathroom)) {
                        if (bathroom.id == bathroomAttendant.filteredBathrooms.first?.id) {
                            HeaderView(bathroom: bathroom, moreDetail: false)
                        } else {
                            BathroomCellView(bathroom: bathroom)
                        }
                    }
                }
                .listStyle(.plain)
                
                if let events = eventAttendant.events?.filter({ $0.structuredLocation != nil }) {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(events, id: \.self) { event in
                                VStack {
                                    Text(event.title)
                                        .font(.headline)
                                    if let location = event.location {
                                        Text(location)
                                            .font(.callout)
                                    }
                                }.padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(uiColor: .secondarySystemBackground))
                                }
                            }
                        }
                    }.frame(height: 100)
                }
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
            .navigationDestination(isPresented: $showBathroom) {
                BathroomView(bathroom: $bathroomAttendant.closestBathroom)
            }.onOpenURL { url in
                print("Received deep link: \(url)")
                self.showBathroom = true
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
