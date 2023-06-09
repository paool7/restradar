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
    @ObservedObject private var settingsAttendant = SettingsAttendant.shared

    @Environment(\.scenePhase) var scenePhase
    
    @State private var showLocation = false
    @State private var showSettings = false
    @State private var showBathroom = false
    @State var selectedBathroom: String = ""
        
    var body: some View {
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(bathroomAttendant.filteredBathrooms) { bathroom in
                            NavigationLink(destination: BathroomView(bathroom: bathroom)) {
                                BathroomSummaryView(bathroom: bathroom)
                                    .background {
                                        Color(uiColor: .secondarySystemBackground)
                                    }
                                    .cornerRadius(16)
                            }
                        }
                        
                    }
                }.refreshable {
                    
                }
            }
            .padding(4)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            self.showSettings = true
                        } label: {
                            Image(systemName: "gear")
                            
                        }
                        
                        //                        Button {
                        //                            self.showLocation = !self.showLocation
                        //                        } label: {
                        //                            Image(systemName: "location.magnifyingglass")
                        //                                .if(locationAttendant.selectedSearchLocation != nil) { $0.shiny(.iridescent2) }
                        //                                .foregroundColor(.primary)
                        //                        }
                        //                        .popover(isPresented: $showLocation, attachmentAnchor: .point(.trailing), arrowEdge: .top) {
                        //                            LocationSearchView(locationService: locationAttendant.locationService)
                        //                        }
                        
                        if !bathroomAttendant.favoriteBathrooms.isEmpty {
                            Button {
                                bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
                            } label: {
                                Image(systemName: bathroomAttendant.onlyFavorites ? "bookmark.fill" : "bookmark")
                                    .if(bathroomAttendant.onlyFavorites) { $0.shiny(Gradient.forCurrentTime() ?? .iridescent2) }
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            if bathroomAttendant.onlyFavorites {
                                Text("Only Favorites")
                            }
                        }
                    }.scaledToFill()
                    .environment(\.layoutDirection, settingsAttendant.primaryHand == .right ? .rightToLeft : .leftToRight)
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
                if let bathroom = bathroomAttendant.filteredBathrooms.first(where: { $0.id == self.selectedBathroom }) {
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
