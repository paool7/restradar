//
//  HomeView.swift
//  G2G
//
//  Created by Paul Dippold on 3/5/23.
//

import SwiftUI
import MapKit
import CoreLocation
import Foundation

struct HomeView: View {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared
    @StateObject private var eventAttendant = EventsRepository.shared

    @Environment(\.scenePhase) var scenePhase
    
    @State private var showLocation = false
    @State private var showSettings = false
    @State private var showBathroom = false
    @State var selectedBathroom: String = "Nearby"
    
    let mode = [HomeMode.nearby, HomeMode.calendar]
    @State var selectedMode = HomeMode.nearby

    var columns: [GridItem] = [
        GridItem(.flexible(maximum: UIScreen.screenWidth/2-24), spacing: 8),
        GridItem(.flexible(maximum: (UIScreen.screenWidth-24)/2), spacing: 8),
]
    
    var body: some View {
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach($bathroomAttendant.filteredBathrooms) { bathroom in
                        NavigationLink(destination: BathroomView(bathroom: bathroom)) {
                            BathroomSummaryView(bathroom: bathroom)
                                .background {
                                    Color(uiColor: .secondarySystemBackground)
                                }
                                .cornerRadius(16)
                        }
                    }
                }.refreshable {
                    
                }
            }
            .padding(4)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if SettingsAttendant.shared.primaryHand == .left {
                        Button {
                            self.showSettings = true
                        } label: {
                            Image(systemName: "gear")
                            
                        }
                        
                        Button {
                            self.showLocation = !self.showLocation
                        } label: {
                            Image(systemName: "location.magnifyingglass")
                                .if(locationAttendant.selectedSearchLocation != nil) { $0.shiny(.iridescent2) }
                                .foregroundColor(.primary)
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
                        
                        Button {
                            bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
                        } label: {
                            Image(systemName: bathroomAttendant.onlyFavorites ? "bookmark.fill" : "bookmark")
                                .if(bathroomAttendant.onlyFavorites) { $0.shiny(.iridescent2) }
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack {
                            if bathroomAttendant.onlyFavorites {
                                Text("Only Favorites")
                            }
                        }
                    } else {
                        VStack {
                            if bathroomAttendant.onlyFavorites {
                                Text("Only Favorites")
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
                        } label: {
                            Image(systemName: bathroomAttendant.onlyFavorites ? "bookmark.fill" : "bookmark")
                                .if(bathroomAttendant.onlyFavorites) { $0.shiny(.iridescent2) }
                                .foregroundColor(.primary)
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
                        
                        Button {
                            self.showLocation = !self.showLocation
                        } label: {
                            Image(systemName: "location.magnifyingglass")
                                .if(locationAttendant.selectedSearchLocation != nil) { $0.shiny(.iridescent2) }
                                .foregroundColor(.primary)
                        }
                        .popover(isPresented: $showLocation, attachmentAnchor: .point(.trailing), arrowEdge: .top) {
                            LocationSearchView(locationService: locationAttendant.locationService)
                        }
                        
                        Button {
                            self.showSettings = true
                        } label: {
                            Image(systemName: "gear")
                            
                        }
                    }
                }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .light)
                UITabBar.appearance().scrollEdgeAppearance = appearance
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
                if let bathroom = $bathroomAttendant.filteredBathrooms.first(where: { $0.wrappedValue.id == self.selectedBathroom }) {
                    BathroomView(bathroom: bathroom)
                }
            }.onOpenURL { url in
                if let host = url.host(), bathroomAttendant.filteredBathrooms.contains(where: {$0.id == host}) {
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
        HomeView()
    }
}
