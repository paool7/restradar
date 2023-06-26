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
import MapKit

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
    @Published var allBathrooms: [Bathroom] = []
    @Published var filteredBathrooms: [Bathroom] = []
    
    @Published var closestFavoriteBathroom: Bathroom?
    @Published var favoriteBathrooms: [Bathroom] = []
    
    @Published var visibleBathrooms: [Bathroom] = []
    @Published var walkingDistance: Double?
    @Published var walkingTime: Int?

    var initialDirectionsLoad = true
    
    init(){
        let all = Constants.getBathrooms()
        self.allBathrooms = all
        self.closestBathroom = all.first!
        
        self.$codesState.sink { [weak self] codesState in
            guard let self = self else { return }

            self.filterBathrooms(onlyFavorites: self.onlyFavorites)
        }.store(in: &subscriptions)
        
        self.$onlyFavorites.sink { [weak self] onlyFavorites in
            self?.filterBathrooms(onlyFavorites: onlyFavorites)

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
            guard let self = self else { return }
            if let bathroomIds = userDefaults?.object(forKey: "FavoriteBathroomsIdStrings") as? [String], !bathroomIds.isEmpty {
                self.favoriteBathrooms = bathroomIds.compactMap({ id in bathrooms.first(where: { $0.id == id }) })
            }
            
            self.filterBathrooms(onlyFavorites: self.onlyFavorites)
        }.store(in: &subscriptions)
        
        self.$visibleBathrooms.sink {  [weak self] bathrooms in
            guard let self = self else { return }
            self.recalculateWalkingDistance()
        }.store(in: &subscriptions)

        LocationAttendant.shared.$current.sink { [weak self] location in
            guard let self = self else { return }
            if self.allBathrooms.count == 0 {
                self.allBathrooms = Constants.getBathrooms()
            }
            self.filterBathrooms(onlyFavorites: self.onlyFavorites)
            
            self.recalculateWalkingDistance()
        }.store(in: &subscriptions)
    }
    
    func filterBathrooms(onlyFavorites: Bool) {
        var bathroomList = onlyFavorites ? favoriteBathrooms : self.allBathrooms
        bathroomList = bathroomList.sorted(by: { $0.distanceMeters()?.value ?? 1000 < $1.distanceMeters()?.value ?? 1000 })
        
        let constrainedBathrooms = bathroomList.count > 101 ? Array(bathroomList[0..<100]) : bathroomList

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
        bathroomList = bathroomList.sorted(by: { $0.distanceMeters()?.value ?? 1000 < $1.distanceMeters()?.value ?? 1000 })
        bathroomList = codesState == .all ? bathroomList : (codesState == .noCodes ? bathroomList.filter({ $0.code == nil }) : bathroomList.filter({ $0.code != nil }))
        return bathroomList.first
    }
    
    func recalculateWalkingDistance() {
        let bathrooms = self.visibleBathrooms.sorted(by: {$0.distanceMeters()?.converted(to: .meters).value ?? 0.0 < $1.distanceMeters()?.converted(to: .meters).value ?? 0.0 })
        if let last = bathrooms.last, let distance = last.distanceMeters()?.converted(to: .meters).value {
            self.walkingDistance = distance
            self.walkingTime = last.totalTime()
        }
    }
}
