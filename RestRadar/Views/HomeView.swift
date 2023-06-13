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
        VStack(spacing: 8) {
            if let current = Binding<CLLocation>($locationAttendant.current), let currentHeading = Binding<Double>($locationAttendant.currentHeading), let walkingDistance = Binding<Double>($bathroomAttendant.walkingDistance) {
                WalkingDistanceMapView(bathroom: bathroomAttendant.closestBathroom, walkingDistance: walkingDistance, current: current, currentHeading: currentHeading)
                    .cornerRadius(20)
                    .frame(height: 200)
            }

                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(bathroomAttendant.filteredBathrooms) { bathroom in
                            NavigationLink(destination: BathroomView(bathroom: bathroom)) {
                                BathroomSummaryView(bathroom: bathroom)
                                    .background {
                                        Color(uiColor: .secondarySystemBackground)
                                    }
                                    .cornerRadius(16)
                                    .onAppear {
                                        bathroomAttendant.visibleBathrooms.append(bathroom)
                                    }
                                    .onDisappear {
                                        if let index = bathroomAttendant.visibleBathrooms.firstIndex(where: {$0.id == bathroom.id }) {
                                            bathroomAttendant.visibleBathrooms.remove(at: index)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding(4)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
