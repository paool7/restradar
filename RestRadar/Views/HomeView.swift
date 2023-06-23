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
import Shiny

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
        VStack(spacing: 2) {
            if let current = Binding<CLLocation>($locationAttendant.current), let currentHeading = Binding<Double>($locationAttendant.currentHeading), let walkingDistance = Binding<Double>($bathroomAttendant.walkingDistance), let walkingTime = bathroomAttendant.walkingTime {
                HStack {
                    ZStack() {
                        WalkingDistanceMapView(bathroom: bathroomAttendant.closestBathroom, walkingDistance: walkingDistance, current: current, currentHeading: currentHeading)
                            .frame(height: 220)
                            .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black, .black, .black, .black, .black, .clear]), startPoint: .bottom, endPoint: .top))
                        ZStack(alignment: .bottom) {
                            Circle()
                                .trim(from: 0.1, to: 0.9)
                                .rotation(.degrees(90))
                                .stroke(Gradient.forCurrentTime()  ?? .iridescent2, style: .init(lineWidth: 4))
                                .frame(width: 215, height: 215)
                            VStack {
                                HStack {
                                    SettingsAttendant.shared.transportMode.image
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 0))
                                    HStack(spacing: 0) {
                                        Text("\(walkingTime)")
                                            .font(.headline)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                                            .id("\(walkingTime)")
                                            .transition(AnyTransition.move(edge: .top))
                                            .animation(.default, value: "\(walkingTime)")
                                        Text("mins")
                                            .font(.headline)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                                    }
                                }
                                .clipped()
                                .background {
                                    Color.black
                                        .cornerRadius(8)
                                        .opacity(0.6)
                                }
                            }
                        }
                    }
                }
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
                    HStack(spacing: -2) {
                        Spacer()
                        
                        if !bathroomAttendant.favoriteBathrooms.isEmpty {
                            Button {
                                bathroomAttendant.onlyFavorites = !bathroomAttendant.onlyFavorites
                            } label: {
                                Group {
                                    HStack {
                                        Image(systemName: bathroomAttendant.onlyFavorites ? "bookmark.fill" : "bookmark")
                                            .foregroundColor(.primary)
                                            .clipped()
                                            .id("\(bathroomAttendant.onlyFavorites)")
                                            .transition(AnyTransition.identity)
                                        if bathroomAttendant.onlyFavorites {
                                            Text("Only Favorites")
                                                .foregroundColor(.primary)
                                                .font(.headline)
                                                .clipped()
                                                .id("\(bathroomAttendant.onlyFavorites)")
                                                .transition(AnyTransition.opacity)
                                        }
                                    }.padding(6)
                                        .clipped()
                                }.background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                                }
                            }
                            .animation(.default, value: bathroomAttendant.onlyFavorites)
                        }
                        
                        Button {
                            self.showSettings = true
                        } label: {
                            Group {
                                Image(systemName: "gear")
                                    .padding(6)
                            }.background {
                            RoundedRectangle(cornerRadius: 12)
                                .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                            }
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
                    }
                }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .light)
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("RestRadar")
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
