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
    @State var selectedBathroom: String = "Nearby"
    
    let mode = [HomeMode.nearby, HomeMode.calendar]
    @State var selectedMode = HomeMode.nearby

    
    var body: some View {
            VStack {
                if selectedMode == .nearby {
                    List($bathroomAttendant.filteredBathrooms) { bathroom in
                        NavigationLink(destination: BathroomView(bathroom: bathroom)) {
                            if (bathroom.id == bathroomAttendant.filteredBathrooms.first?.id) {
                                HeaderView(bathroom: bathroom)
                            } else {
                                BathroomCellView(bathroom: bathroom)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    if let events = eventAttendant.events?.filter({ $0.structuredLocation != nil }) {
                        List(events, id: \.self) { event in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Near \(event.title):")
                                        .font(.title)
                                    Spacer()
                                    if let location = event.structuredLocation?.geoLocation, let closest = bathroomAttendant.findClosestBathroom(to: location) {
                                        BathroomCellView(bathroom: .constant(closest))
                                    }
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(event.startDate.formatted(.dateTime.day().month().hour().minute()))")
                                        .lineLimit(2)
                                        .font(.headline)
                                        .frame(alignment: .trailing)
                                    Spacer()
                                }
                            }
                        }.listStyle(.plain)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if SettingsAttendant.shared.primaryHand == .left {
                        Button {
                            self.showSettings = true
                        } label: {
                            Image(systemName: "gear")
                            
                        }
                        
                        Button {
                            bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
//                        Picker("", selection: $selectedMode) {
//                            ForEach(HomeMode.allCases, id: \.self) {
//                                Text($0.name)
//                            }
//                        }
//                        .pickerStyle(.segmented)
//                        .frame(maxWidth: .infinity)
                    } else {
                        Spacer()
                        
                        Button {
                            bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
                        } label: {
                            Image(systemName: bathroomAttendant.onlyFavorites ? "bookmark.fill" : "bookmark")
                                .if(bathroomAttendant.onlyFavorites) { $0.shiny(.iridescent) }
                                .foregroundColor(.primary)
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
                            if bathroomAttendant.codesState == .all {
                                bathroomAttendant.codesState = .noCodes
                            } else if bathroomAttendant.codesState == .noCodes {
                                bathroomAttendant.codesState = .onlyCodes
                            } else if bathroomAttendant.codesState == .onlyCodes {
                                bathroomAttendant.codesState = .all
                            }
                        } label: {
                            Image(systemName: bathroomAttendant.codesState == .noCodes ? "lock.open" : (bathroomAttendant.codesState == .onlyCodes ? "lock" : "lock.shield"))
                                .foregroundColor(bathroomAttendant.codesState == .noCodes ? .mint : (bathroomAttendant.codesState == .onlyCodes ? .red : .primary))
                        }
                        
//                        Button {
//                            bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
//                        } label: {
//                            Image(systemName: "slider.horizontal.3")
//                                .foregroundColor(.primary)
//                        }
                        
                        Button {
                            self.showSettings = true
                        } label: {
                            Image(systemName: "gear")
                            
                        }
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
                if let bathroom = $bathroomAttendant.sortedBathrooms.first(where: { $0.wrappedValue.id == self.selectedBathroom }) {
                    BathroomView(bathroom: bathroom)
                }
            }.onOpenURL { url in
                if let host = url.host(), bathroomAttendant.sortedBathrooms.contains(where: {$0.id == host}) {
                    self.selectedBathroom = host
                    self.showBathroom = true
                }
            }
    }
    
    func combineStrings(_ string1: String, _ string2: String) -> String {
        // Remove occurrences of "," and "."
        let cleanedString1 = string1.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
        let cleanedString2 = string2.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
        
        // Split the strings into arrays of words
        let words1 = cleanedString1.components(separatedBy: " ")
        let words2 = cleanedString2.components(separatedBy: " ")
        
        // Combine the arrays of words and shuffle them
        var combinedWords = words1 + words2
        combinedWords.shuffle()
        
        // Join the words with "-"
        let result = combinedWords.joined(separator: "-")
        return result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
