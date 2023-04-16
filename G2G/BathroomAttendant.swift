//
//  BathroomAttendant.swift
//  G2G
//
//  Created by Paul Dippold on 3/18/23.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

enum CodesState: Int {
    case noCodes
    case onlyCodes
    case all
}

class BathroomAttendant: ObservableObject {
    static var shared = BathroomAttendant()

    private var subscriptions = Set<AnyCancellable>()

    @Published var codesState: CodesState = .all
    @Published var onlyFavorites = false
        
    @Published var closestBathroom: Bathroom
    @Published var sortedBathrooms: [Bathroom]
    @Published var filteredBathrooms: [Bathroom] = []
    
    @Published var closestFavoriteBathroom: Bathroom?
    @Published var favoriteBathrooms: [Bathroom] = [] {
        didSet {
            let bathroomIds = favoriteBathrooms.map { $0.id }
            userDefaults?.set(bathroomIds, forKey: "FavoriteBathroomsIdStrings")
        }
    }
    
    init(){
        let defaults = [
            Bathroom(name: "HasenStüble", address: "1184 Nostrand Ave., Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6585688, longitude: -73.9506879), id: "Ave-Brooklyn-NY-Nostrand-11225-1184-HasenStüble"),
            Bathroom(name: "Le Point Value Thrift", address: "321 Clarkson Ave, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.6555898, longitude: -73.948961), id: "Clarkson-Ave-NY-Thrift-321-11226-Point-Brooklyn-Value-Le"),
            Bathroom(name: "Winthrop Playground", address: "164 Winthrop St, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.656620, longitude: -73.954193), comment: "Open during park hours", id: "Winthrop-Winthrop-St-Brooklyn-Playground-NY-11226-164"),
            Bathroom(name: "Brooklyn PERK Coffee", address: "605 Flatbush Ave, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.658599, longitude: -73.9603273), comment: "Free unlocked gender neutral/single stall bathroom all the way in the back", id: "11225-NY-Ave-605-PERK-Flatbush-Brooklyn-Brooklyn-Coffee"),
            Bathroom(name: "Nostrand Playground", address: "3002 Foster Ave, Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.638375, longitude: -73.9474496), id: "Playground-Ave-Foster-3002-Brooklyn-Nostrand-NY-11210"),
            Bathroom(name: "LeFrak Center at Lakeside", address: "171 East Dr, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6639138, longitude: -73.9656772), comment: "In Prospect Park", id: "East-NY-171-Dr-Brooklyn-at-LeFrak-11225-Lakeside-Center"),
            Bathroom(name: "Public Bathroom", address: "70 Parade Pl, Brooklyn, NY 1121", coordinate: CLLocationCoordinate2D(latitude: 40.6513557, longitude: -73.9652167), comment: "In Detective Dillon Stewart Playground", id: "Pl-Public-70-Parade-1121-Bathroom-NY-Brooklyn"),
            Bathroom(name: "Public Bathroom", address: "116 East Dr, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6639138, longitude: -73.9656772), comment: "In Prospect Park\nBring your owns tissues if you can because it often runs out. Sometimes closed when it’s supposed to be open.", id: "Public-Dr-Brooklyn-East-Bathroom-NY-11225-116"),
            Bathroom(name: "Brooklyn Public Library- Cortelyou Branch", address: "1305 Cortelyou Rd. at, Argyle Rd, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.6406079, longitude: -73.9660055), id: "Brooklyn-Branch-NY-Rd-Argyle-Library--Cortelyou-Cortelyou-Public-at-11226-Rd-Brooklyn-1305"),
            Bathroom(name: "Wellhouse", address: "200 Well House Dr, Brooklyn, NY 11218", coordinate: CLLocationCoordinate2D(latitude: 40.656594952552695, longitude: -73.97055906109286), comment: "In Prospect Park", id: "NY-Well-Brooklyn-200-11218-House-Dr-Wellhouse"),
            Bathroom(name: "McDonald’s", address: "2154 Nostrand Ave., Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.6323542, longitude: -73.9479889), id: "11210-2154-Ave-McDonald’s-NY-Brooklyn-Nostrand"),
            Bathroom(name: "Agi’s Counter", address: "818 Franklin Ave, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6699908, longitude: -73.958366), comment: "Recommended on Reddit", id: "Franklin-Ave-Counter-818-NY-Agi’s-Brooklyn-11225"),
            Bathroom(name: "Chipotle Mexican Grill", address: "2166 Nostrand Ave., Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.6320053, longitude: -73.9479154), code: "2766", id: "Brooklyn-Chipotle-11210-Ave-Grill-2166-Nostrand-Mexican-NY"),
            Bathroom(name: "Elk Cafe", address: "154 Prospect Park Southwest, Brooklyn, NY 11218", coordinate: CLLocationCoordinate2D(latitude: 40.6549213, longitude: -73.9736356), id: "Cafe-Park-Brooklyn-NY-Elk-Southwest-11218-154-Prospect"),
            Bathroom(name: "Target", address: "1598 Flatbush Ave, Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.6313473, longitude: -73.9463696), comment: "Next to the Starbucks inside the store", id: "NY-Brooklyn-1598-Target-Flatbush-Ave-11210"),
            Bathroom(name: "Starbucks", address: "341 Eastern Pkwy, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6710295, longitude: -73.957498), code: "123456", id: "Eastern-Pkwy-NY-Starbucks-11238-341-Brooklyn"),
            Bathroom(name: "Bagel Pub", address: "775 Franklin Ave, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6722378, longitude: -73.9571095), comment: "Unlocked bathroom", id: "Ave-NY-775-Franklin-Bagel-Pub-Brooklyn-11238"),
            Bathroom(name: "Crown Heights Cafe", address: "764 Franklin Ave, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.672289, longitude: -73.9576119), id: "Cafe-11238-Brooklyn-Heights-764-NY-Franklin-Crown-Ave"),
            Bathroom(name: "Target", address: " 5200 Kings Hwy Ste A, Brooklyn, NY 11234", coordinate: CLLocationCoordinate2D(latitude: 40.6363315, longitude: -73.9274812), id: "A-Brooklyn-11234-5200-Hwy-Target-Ste-Kings-NY"),
            Bathroom(name: "Windsor Terrace Library", address: "160 E 5th St, Brooklyn, NY 11218", coordinate: CLLocationCoordinate2D(latitude: 40.6486979, longitude: -73.9767751), id: "NY-160-St-5th-E-Terrace-Windsor-Brooklyn-Library-11218"),
            Bathroom(name: "Villager", address: "841 Classon Ave, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6719563, longitude: -73.960919), comment: "Unlocked bathroom in the back", id: "NY-Classon-Brooklyn-841-11238-Villager-Ave"),
            Bathroom(name: "Parade Ground Public Restroom", address: "305 Parkside Ave, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.6558738, longitude: -73.9589949), id: "11226-305-Public-Parkside-Ave-NY-Ground-Brooklyn-Restroom-Parade"),
            Bathroom(name: "Brooklyn Museum", address: "200 Eastern Parkway, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6713414, longitude: -73.9636813), id: "200-NY-11238-Museum-Parkway-Eastern-Brooklyn-Brooklyn"),
            Bathroom(name: "Picnic House", address: "40 West Dr, Brooklyn, NY 11215", coordinate: CLLocationCoordinate2D(latitude: 40.6696918, longitude: -73.9718209), comment: "In Prospect Park", id: "Picnic-40-NY-West-11215-Dr-Brooklyn-House"),
            Bathroom(name: "St Johns Park", address: "Troy Ave, Brooklyn, NY 11213", coordinate: CLLocationCoordinate2D(latitude: 40.6777027, longitude: -73.9358504), comment: "Usually open from early morning to late at night", id: "11213-Johns-Troy-St-Ave-Brooklyn-Park-NY")
            ]
        
        self.sortedBathrooms = defaults
        self.closestBathroom = defaults[0]

        if let bathroomIds = userDefaults?.object(forKey: "FavoriteBathroomsIdStrings") as? [String] {
            self.favoriteBathrooms = bathroomIds.compactMap({ id in self.sortedBathrooms.first(where: { $0.id == id }) })
        }
        
        self.$codesState.sink { [weak self] codesState in
            if let onlyFavorites = self?.onlyFavorites, let filteredBathroom = self?.filterBathrooms(onlyFavorites: onlyFavorites, codesState: codesState) {
                self?.filteredBathrooms = filteredBathroom
            }
        }.store(in: &subscriptions)
        
        self.$onlyFavorites.sink { [weak self] onlyFavorites in
            if let filteredBathroom = self?.filterBathrooms(onlyFavorites: onlyFavorites, codesState: self?.codesState) {
                self?.filteredBathrooms = filteredBathroom
            }
        }.store(in: &subscriptions)
        
        self.$favoriteBathrooms.sink {  [weak self] bathrooms in
            if let firstFavorite = self?.favoriteBathrooms.first {
                self?.closestFavoriteBathroom = firstFavorite
            }
        }.store(in: &subscriptions)
        
        self.$sortedBathrooms.sink {  [weak self] bathrooms in
            if let onlyFavorites = self?.onlyFavorites, let filteredBathroom = self?.filterBathrooms(onlyFavorites: onlyFavorites, codesState: self?.codesState) {
                self?.filteredBathrooms = filteredBathroom
            }
            if let firstSorted = self?.filteredBathrooms.first {
                self?.closestBathroom = firstSorted
            }
        }.store(in: &subscriptions)
    }
    
    func filterBathrooms(onlyFavorites: Bool, codesState: CodesState?) -> [Bathroom] {
        guard let current = LocationAttendant.shared.current else { return [] }
        var bathroomList = onlyFavorites ? favoriteBathrooms : sortedBathrooms
        bathroomList = bathroomList.sorted(by: { $0.distanceMeters(current: current)?.value ?? 1000 < $1.distanceMeters(current: current)?.value ?? 1000 })
        bathroomList = codesState == .all ? bathroomList : (codesState == .noCodes ? bathroomList.filter({ $0.code == nil }) : bathroomList.filter({ $0.code != nil }))
        return bathroomList
    }
    
    func findClosestBathrooms() async throws -> Bathroom {
        while LocationAttendant.shared.current == nil {
            
        }
        return self.closestBathroom
    }
    
    func findClosestBathroom(to current: CLLocation) -> Bathroom? {
        var bathroomList = onlyFavorites ? favoriteBathrooms : sortedBathrooms
        bathroomList = bathroomList.sorted(by: { $0.distanceMeters(current: current)?.value ?? 1000 < $1.distanceMeters(current: current)?.value ?? 1000 })
        bathroomList = codesState == .all ? bathroomList : (codesState == .noCodes ? bathroomList.filter({ $0.code == nil }) : bathroomList.filter({ $0.code != nil }))
        return bathroomList.first
    }
}
