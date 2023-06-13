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
                    if let current = locationAttendant.current {
                        HStack {
                            if bathroom.totalTime(current: current) > 0 {
                                Spacer()
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(bathroom.totalTime(current: current))")
                                            .font(.largeTitle)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.primary)
                                        SettingsAttendant.shared.transportMode.image
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
                                    if SettingsAttendant.shared.distanceMeasurement == .blocks, let totalBlocks = bathroom.blockEstimate(current: current), totalBlocks > 0 {
                                        Text("~\(totalBlocks)")
                                            .lineLimit(1)
                                            .font(.title)
                                            .foregroundColor(.primary)
                                    } else if SettingsAttendant.shared.distanceMeasurement == .miles, let distance = bathroom.distance(current: current) {
                                        Text(String(format: "%.1f", distance))
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
                    }
                    if let address = bathroom.address {
                        Divider()
                            .overlay(.primary)
                        LookAroundView(scene: self.$scene)
                            .cornerRadius(8)
                            .clipped()
                            .frame(height: 120)
                        Text("\(address)")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .frame(alignment: .center)
                    }
                    Divider()
                        .overlay(.primary)
                    
                    if let urlString = bathroom.url, let url = URL(string: urlString) {
                        Button {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } label: {
                            HStack {
                                Text("More Info")
                                    .foregroundColor(.cyan)
                                    .font(.headline)
                                    .frame(alignment: .center)
                                Image(systemName: "safari")
                                    .foregroundColor(.cyan)
                                    .font(.headline)
                            }
                        }
                    }
                }
                .padding(16)
                .background {
                    Color(uiColor: .secondarySystemBackground)
                        .cornerRadius(16)
                }
                                
                DirectionsView(bathroom: bathroom)
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
                HStack {
                    Button {
                        let coordinate = CLLocationCoordinate2DMake(bathroom.coordinate.latitude, bathroom.coordinate.longitude)
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                        mapItem.name = self.bathroom.name
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
                        
                        //                    if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(location.coordinate.latitude),\(location.coordinate.longitude)&directionsmode=driving") {
                        //                            UIApplication.shared.open(url, options: [:])
                        //                        }
                    } label: {
                        Text("Open In Maps")
                            .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                    }
                    
                    Button {
                        if let index = bathroomAttendant.favoriteBathrooms.firstIndex(where: { $0.id == bathroom.id }) {
                            bathroomAttendant.favoriteBathrooms.remove(at: index)
                        } else {
                            bathroomAttendant.favoriteBathrooms.append(bathroom)
                        }
                    } label: {
                        Image(systemName: bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id })  ? "bookmark.fill" : "bookmark")
                            .if(bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id })) { $0.shiny(Gradient.forCurrentTime() ?? .iridescent2) }
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }.scaledToFill()
                .environment(\.layoutDirection, SettingsAttendant.shared.primaryHand == .right ? .rightToLeft : .leftToRight)
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
