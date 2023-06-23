//
//  BathroomView.swift
//  G2G
//
//  Created by Paul Dippold on 3/19/23.
//

import SwiftUI
import MapKit
import Shiny
import SafariServices

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
                
                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        if bathroom.totalTime() ?? 0 > 0 {
                            Spacer()
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(bathroom.totalTime() ?? 0)")
                                        .font(.largeTitle)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.primary)
                                    Image(systemName: "hourglass")
                                        .font(.title3)
                                }
                                Text("mins")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }.fixedSize(horizontal: true, vertical: true)
                            Spacer()
                        }
                        
                        Divider()
                            .overlay(.primary)
                        Spacer()
                        VStack(alignment: .leading) {
                            HStack {
                                if let distanceString = bathroom.distanceString(withUnit: false) {
                                    Text(distanceString)
                                        .lineLimit(1)
                                        .font(.title)
                                        .foregroundColor(.primary)
                                }
                                
                                SettingsAttendant.shared.distanceMeasurement.image
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                            Text(SettingsAttendant.shared.distanceMeasurement.name.lowercased())
                                .font(.caption)
                                .foregroundColor(.primary)
                        }.fixedSize(horizontal: true, vertical: true)
                        Spacer()
                        
                        if let code = bathroom.code {
                            Divider()
                                .overlay(.primary)
                            Spacer()
                            VStack(alignment: .center) {
                                HStack(alignment:.center) {
                                    Text("\(code)")
                                        .font(.largeTitle)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.primary)
                                    Image(systemName: "lock.shield")
                                        .font(.title3)
                                }
                                Text("code")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }.fixedSize(horizontal: true, vertical: true)
                            Spacer()
                        }
                        
                        Divider()
                            .overlay(.primary)
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("In")
                                    .lineLimit(1)
                                    .font(.title)
                                    .foregroundColor(.primary)
                                bathroom.category.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: UIFont.preferredFont(forTextStyle: .title2).pointSize)
                                    .foregroundColor(.primary)
                            }
                            Text(bathroom.category.rawValue.lowercased())
                                .font(.caption)
                                .foregroundColor(.primary)
                        }.fixedSize(horizontal: true, vertical: true)
                        Spacer()
                    }
                    .frame(height: 50)
                    //                    Divider()
                    //                        .overlay(.primary)
                    
                    if let address = bathroom.address {
                        Divider()
                            .overlay(.primary)
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.primary)
                                .font(.headline)
                            Text("\(address)")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .frame(alignment: .center)
                        }
                        
                        LookAroundView(scene: self.$scene)
                            .cornerRadius(8)
                            .clipped()
                            .frame(height: 120)
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
            Task {
                let scene = await getScene(location: .init(latitude: bathroom.coordinate.latitude, longitude: bathroom.coordinate.longitude))
                self.scene = scene
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack(spacing: -2) {
                    Button {
                        if SettingsAttendant.shared.mapProvider == .apple {
                            let coordinate = CLLocationCoordinate2DMake(bathroom.coordinate.latitude, bathroom.coordinate.longitude)
                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                            mapItem.name = self.bathroom.name
                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
                        } else {
                            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(bathroom.coordinate.latitude),\(bathroom.coordinate.longitude)&directionsmode=walking") {
                                    UIApplication.shared.open(url, options: [:])
                            }
                        }
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
    
    func getScene(location: CLLocationCoordinate2D?) async -> MKLookAroundScene? {
        if let latitude = location?.latitude, let longitude = location?.longitude {
            let sceneRequest = MKLookAroundSceneRequest(coordinate: .init(latitude: latitude, longitude: longitude))
            
            do {
                return try await sceneRequest.scene
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

struct BathroomView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}
