//
//  BathroomView.swift
//  G2G
//
//  Created by Paul Dippold on 3/19/23.
//

import Karte
import MapKit
import SafariServices
import Shiny
import SwiftUI
import TelemetryClient

struct BathroomView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @StateObject var bathroom: Bathroom
    
    @State var scene: MKLookAroundScene?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(bathroom.name)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Spacer()
                }
                if let address = bathroom.address {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.primary)
                            .font(.headline)
                        Text("\(address)")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(alignment: .center)
                    }
                }
                
                VStack(alignment: .center, spacing: 8) {
                    LookAroundView(scene: self.$scene)
                        .cornerRadius(8)
                        .clipped()
                        .frame(height: 120)
                    
                    Button {
                        self.openMaps()
                    } label: {
                        CompassView(bathroom: bathroom)
                            .frame(height: 325)
                    }
                    
                    DirectionsView(bathroom: bathroom)
                }
                .padding(16)
                .background {
                    Color(uiColor: .secondarySystemBackground)
                        .cornerRadius(16)
                }
            }
            .padding(8)
        }
        .onAppear {
            if self.scene == nil {
                Task {
                    let scene = await LocationAttendant.shared.getScene(location: .init(latitude: bathroom.coordinate.latitude, longitude: bathroom.coordinate.longitude))
                    self.scene = scene
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack(spacing: -2) {
                    Button {
                        self.openMaps()
                    } label: {
                        Group {
                            HStack(spacing: 4) {
                                Image(systemName: "map")
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                Text("Maps")
                                    .foregroundColor(.primary)
                                    .font(.headline)
                            }.padding(6)
                        }.background {
                            RoundedRectangle(cornerRadius: 12)
                                .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                        }
                    }
                    
                    if let urlString = bathroom.url, let url = URL(string: urlString) {
                        Button {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } label: {
                            Group {
                                HStack(spacing: 4) {
                                    Image(systemName: "safari")
                                        .foregroundColor(.primary)
                                        .font(.headline)
                                    Text("Info")
                                        .foregroundColor(.primary)
                                        .font(.headline)
                                }.padding(6)
                            }.background {
                                RoundedRectangle(cornerRadius: 12)
                                    .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                            }
                        }
                    }
                    
                    Spacer()
                                        
                    let isFavorite = bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id })
                    Button {
                        if let index = bathroomAttendant.favoriteBathrooms.firstIndex(where: { $0.id == bathroom.id }) {
                            bathroomAttendant.favoriteBathrooms.remove(at: index)
                        } else {
                            bathroomAttendant.favoriteBathrooms.append(bathroom)
                        }
                    } label: {
                        Group {
                            HStack(spacing: 4) {
                                Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .clipped()
                                    .id("\(isFavorite)")
                                    .transition(AnyTransition.opacity)
                                if !isFavorite {
                                    Text("Save")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .clipped()
                                        .id("\(isFavorite)")
                                        .transition(AnyTransition.opacity)
                                }
                            }.padding(6)
                                .clipped()
                        }.background {
                            RoundedRectangle(cornerRadius: 12)
                                .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                        }
                    }
                    .animation(.bouncy, value: isFavorite)
                }
            }
        }
    }
    
    func openMaps() {
        let bathroomLocation = Karte.Location(name: bathroom.name, coordinate: bathroom.coordinate)
        do {
            let provider = SettingsAttendant.shared.mapProvider
            if provider.supportsWalking {
                try Karte.launch(app: provider, destination: bathroomLocation, mode: .walking)
            } else {
                Karte.launch(app: provider, destination: bathroomLocation)
            }
        } catch {
            print(error)
            TelemetryManager.send("Error", with: ["type": "KarteLaunch", "message": error.localizedDescription])
        }
    }
}

struct BathroomView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}
