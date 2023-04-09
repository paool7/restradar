//
//  LocationAttendant.swift
//  G2G
//
//  Created by Paul Dippold on 3/19/23.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationAttendant: NSObject, ObservableObject {
    static let shared = LocationAttendant()
    
    private let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    @Published var current: CLLocation?
    @Published var currentHeading: CLLocationDegrees = 0.0
    
    private var getFirst = true
    
    override init() {
        super.init()
        self.locationManager.delegate = self
//        self.locationManager.headingFilter = 2.0
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.authorizationStatus = self.locationManager.authorizationStatus
        self.startUpdating()

    #if targetEnvironment(simulator)
        self.current = CLLocation(latitude: 40.652005801809445, longitude: -73.94718932404285)
        self.currentHeading = -12.0 //6.162876129150391
        self.getDistances()
        self.getHeadings()
    #endif
    }
    
    public func requestAuthorization() {
        if self.authorizationStatus == .authorizedWhenInUse {
            LocationAttendant.shared.startUpdating()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdating() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
    }
    
    func stopUpdating() {
        self.locationManager.stopUpdatingHeading()
        self.locationManager.stopUpdatingLocation()
    }
    
//    func getLocations() {
//        let group = DispatchGroup()
//
//        let bathrooms = BathroomAttendant.shared.sortedBathrooms.filter({ $0.lat == nil && $0.long == nil})
//        for i in 0..<bathrooms.count {
//            group.enter()
//
//            var bathroom = bathrooms[i]
//            self.getLocation(from: bathroom.address) { location in
//                bathroom.lat = location?.coordinate.latitude
//                bathroom.long = location?.coordinate.longitude
//                BathroomAttendant.shared.changeDefault(bathroom.id, to: bathroom)
//                group.leave()
//            }
//        }
//
//        group.notify(queue: DispatchQueue.main) {
//            for bathroom in BathroomAttendant.shared.sortedBathrooms {
//                if let coordinate = bathroom.coordinate {
//                    print(bathroom.id)
//                    print(coordinate)
//                }
//            }
//
//
//        }
//    }
    
    func getDistances() {
        for i in 0..<BathroomAttendant.shared.sortedBathrooms.count {
            if let current = self.current {
                let location = CLLocation(latitude: BathroomAttendant.shared.sortedBathrooms[i].coordinate.latitude, longitude: BathroomAttendant.shared.sortedBathrooms[i].coordinate.longitude)
                let locationDistance = location.distance(from: current)
                
                let distanceMeters = Measurement(value: locationDistance, unit: UnitLength.meters)
                BathroomAttendant.shared.sortedBathrooms[i].distanceMeters = distanceMeters.value
                
                if var distance = BathroomAttendant.shared.sortedBathrooms[i].distanceMeters {
                    let distanceMiles = distanceMeters.converted(to: .miles)
                    let distanceFeet = distanceMeters.converted(to: .feet)
                    let useMiles = (distanceMiles.value >= 0.25)
                    distance = useMiles ? round(distanceMiles.value * 10) / 10.0 : round(distanceFeet.value)
                    
                    if BathroomAttendant.shared.sortedBathrooms[i].timeAway == nil {
                        BathroomAttendant.shared.sortedBathrooms[i].timeAway = "\(locationDistance.travelTime) minute\(locationDistance.travelTime == 1 ? "" : "s")"
                    }
                    BathroomAttendant.shared.sortedBathrooms[i].distanceAway = "\(distance) \(useMiles ? "Miles" : "Feet")"
                    BathroomAttendant.shared.sortedBathrooms[i].stepsAway = "~\(distanceMeters.value.steps) step\(distanceMeters.value.steps == 1 ? "" : "s")"
                }
            }
        }
        BathroomAttendant.shared.sortedBathrooms = BathroomAttendant.shared.sortedBathrooms.sorted(by: { $0.distanceMeters ?? 1000 < $1.distanceMeters ?? 1000 })
        BathroomAttendant.shared.closestBathroom = BathroomAttendant.shared.sortedBathrooms[0]
        if getFirst, let first = BathroomAttendant.shared.sortedBathrooms.first {
            self.getDirections(to: first.id)
            self.getFirst = false
        }
    }
    
    func getDirections(to toId: Int) {
        if let current = self.current, let index = BathroomAttendant.shared.sortedBathrooms.firstIndex(where: {$0.id == toId}) {
            self.getTravelDirections(sourceLocation: current.coordinate, endLocation: BathroomAttendant.shared.sortedBathrooms[index].coordinate) { directions, route in
                BathroomAttendant.shared.sortedBathrooms[index].directions = directions
                BathroomAttendant.shared.sortedBathrooms[index].route = route
                BathroomAttendant.shared.closestBathroom = BathroomAttendant.shared.sortedBathrooms[0]
                if let travelTime = route?.expectedTravelTime {
                    let travelMinutes = Int(travelTime/60)
                    BathroomAttendant.shared.sortedBathrooms[index].timeAway = "\(travelMinutes) minute\(travelMinutes == 1 ? "" : "s")"
                }
                if let firstStep = directions.first {
                    BathroomAttendant.shared.sortedBathrooms[index].heading = firstStep.streetHeading
                }
            }
        }
    }
    
    func getHeadings() {
        for bathroom in BathroomAttendant.shared.sortedBathrooms {
            if !bathroom.directions.isEmpty {
                let firstStep = bathroom.directions[0]
                bathroom.heading = firstStep.streetHeading
            }
            if let current = self.current {
                bathroom.generalHeading = self.currentHeading.angle(current.coordinate, bathroom.coordinate)
                if bathroom.id == BathroomAttendant.shared.closestBathroom.id {
//                    print("Heading: \(bathroom.generalHeading)")
                }
            }
        }
        BathroomAttendant.shared.closestBathroom = BathroomAttendant.shared.sortedBathrooms[0]
    }
    
    private func getLocation(from address: String, completion: @escaping (_ location: CLLocation?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    func getTravelDirections(sourceLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D, completion: @escaping (_ directions: [MKRoute.Step], _ route: MKRoute?) -> (Void)){
        let request = MKDirections.Request()
        let source = MKPlacemark( coordinate: sourceLocation)
        let destination = MKPlacemark( coordinate: endLocation)
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = false
        let directions = MKDirections ( request: request)
        directions.calculate { (response, error) in
            if let error = error {
                print("Distance directions calculation error\n \(error.localizedDescription)")
                return
            }
            if let routes = response?.routes, let shortestRoute = routes.sorted(by: { $0.expectedTravelTime < $1.expectedTravelTime}).first {
                completion(shortestRoute.steps, shortestRoute)
            }
        }
    }
}

extension LocationAttendant: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        self.startUpdating()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        self.current = lastLocation
        
        self.getDistances()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentHeading = newHeading.trueHeading

        self.getHeadings()
    }
}
