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
        
    @Published var closestBathroom: Bathroom = Bathroom(name: "", accessibility: .unknown, coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), id: "first")
    @Published var allBathrooms: [Bathroom] = []
    @Published var filteredBathrooms: [Bathroom] = []
    
    @Published var closestFavoriteBathroom: Bathroom?
    @Published var favoriteBathrooms: [Bathroom] = []
    
    var initialDirectionsLoad = true
    
    init(){
        self.$codesState.sink { [weak self] codesState in
            self?.filterBathrooms()

        }.store(in: &subscriptions)
        
        self.$onlyFavorites.sink { [weak self] onlyFavorites in
            self?.filterBathrooms()

        }.store(in: &subscriptions)
        
        self.$favoriteBathrooms.sink {  [weak self] bathrooms in
            if let firstFavorite = self?.favoriteBathrooms.first {
                self?.closestFavoriteBathroom = firstFavorite
            }
            
            let bathroomIds = bathrooms.map { $0.id }
            if !bathroomIds.isEmpty {
                userDefaults?.set(bathroomIds, forKey: "FavoriteBathroomsIdStrings")
            }
        }.store(in: &subscriptions)
        
        self.$allBathrooms.sink {  [weak self] bathrooms in
            self?.filterBathrooms()
            
//            for bathroom in bathrooms {
//                print(bathroom.id)
//            }
            
            if let bathroomIds = userDefaults?.object(forKey: "FavoriteBathroomsIdStrings") as? [String], !bathroomIds.isEmpty {
                self?.favoriteBathrooms = bathroomIds.compactMap({ id in bathrooms.first(where: { $0.id == id }) })
            }
        }.store(in: &subscriptions)

        LocationAttendant.shared.$current.sink { [weak self] location in
            if self?.allBathrooms.count == 0 {
                self?.allBathrooms = Constants.getBathrooms()
            }
            self?.filterBathrooms()
        }.store(in: &subscriptions)
    }
    
    func filterBathrooms() {
        guard let current = LocationAttendant.shared.current else {
            return
        }
        var bathroomList = onlyFavorites ? favoriteBathrooms : self.allBathrooms
        bathroomList = bathroomList.sorted(by: { $0.distanceMeters(current: current)?.value ?? 1000 < $1.distanceMeters(current: current)?.value ?? 1000 })
        bathroomList = codesState == .all ? bathroomList : (codesState == .noCodes ? bathroomList.filter({ $0.code == nil }) : bathroomList.filter({ $0.code != nil }))
        
        let constrainedBathrooms = bathroomList.count > 75 ? Array(bathroomList[0..<75]) : bathroomList
//        let constrainedBathrooms = bathroomList

        self.filteredBathrooms = constrainedBathrooms
        
        if let firstSorted = constrainedBathrooms.first {
            self.closestBathroom = firstSorted
        }
    }
    
    func findClosestBathrooms() async throws -> Bathroom {
        while LocationAttendant.shared.current == nil {
            
        }
        return self.closestBathroom
    }
    
    func findClosestBathroom(to current: CLLocation) -> Bathroom? {
        var bathroomList = onlyFavorites ? favoriteBathrooms : allBathrooms
        bathroomList = bathroomList.sorted(by: { $0.distanceMeters(current: current)?.value ?? 1000 < $1.distanceMeters(current: current)?.value ?? 1000 })
        bathroomList = codesState == .all ? bathroomList : (codesState == .noCodes ? bathroomList.filter({ $0.code == nil }) : bathroomList.filter({ $0.code != nil }))
        return bathroomList.first
    }
    
    struct PublicRestroom {
        let name: String
        let parkName: String
        let parkURL: String
        let address: String
    }
}
