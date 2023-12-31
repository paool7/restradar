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
import TelemetryClient

struct HomeView: View {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared
    @ObservedObject private var settingsAttendant = SettingsAttendant.shared

    @Environment(\.scenePhase) var scenePhase
    
    @State private var showLocation = false
    @State private var showSettings = false
    @State private var showBathroom = false
    @State var selectedBathroom: String = ""
    
    @State private var showNewBathroom = false

    var body: some View {
        GeometryReader { geometry in
        VStack(spacing: 2) {
            if let current = Binding<CLLocation>($locationAttendant.current), let currentHeading = Binding<Double>($locationAttendant.currentHeading), let walkingDistance = Binding<Double>($bathroomAttendant.walkingDistance), let walkingTime = bathroomAttendant.walkingTime {
                HStack {
                    ZStack() {
                        WalkingDistanceMapView(bathroom: bathroomAttendant.closestBathroom, walkingDistance: walkingDistance, current: current, currentHeading: currentHeading)
                            .frame(height: 225)
                            .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black, .black, .black, .black, .black, .clear]), startPoint: .bottom, endPoint: .top))
                        ZStack(alignment: .bottom) {
                            ZStack {
                                Circle()
                                    .trim(from: 0.1, to: 0.9)
                                    .rotation(.degrees(90))
                                    .stroke(Color.black.opacity(0.6), style: .init(lineWidth: 6))
                                    .cornerRadius(107.5)
                                    .frame(width: 215, height: 215)
                                Circle()
                                    .trim(from: 0.1, to: 0.9)
                                    .rotation(.degrees(90))
                                    .stroke(Color.white, style: .init(lineWidth: 1))
                                    .cornerRadius(107.5)
                                    .frame(width: 215, height: 215)
                            }
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
            if !PurchaseAttendant.shared.hasTipped {
                BannerVC(size: CGSize(width: geometry.size.width, height: 75), adUnitId: "ca-app-pub-3940256099942544/2934735716")
                    .background {
                        Color(uiColor: .secondarySystemBackground)
                    }
                    .cornerRadius(16)
                    .frame(height: 75)
            }
        }
        .padding(4)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack(spacing: -2) {
                    Button {
                        self.showNewBathroom.toggle()
                    } label: {
                        Group {
                            HStack(spacing: 4) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.primary)
                                    .font(.headline)
                            }.padding(6)
                        }.background {
                            RoundedRectangle(cornerRadius: 12)
                                .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                        }
                    }
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
                        self.showSettings.toggle()
                    } label: {
                        Group {
                            HStack(spacing: 4) {
                                Image(systemName: "gear")
                            }.padding(6)
                        }.background {
                            RoundedRectangle(cornerRadius: 12)
                                .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("RestRadar")
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                locationAttendant.requestAuthorization()
            } else if newPhase == .background {
                locationAttendant.stopUpdating()
            }
        }
        .navigationDestination(isPresented: $showNewBathroom) {
            NewBathroomView(isPresented: $showNewBathroom)
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
                self.showBathroom.toggle()
            }
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
