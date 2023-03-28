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
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var current: CLLocation?
    var currentHeading: CLLocationDegrees = 0.0
    
    var getFirst = true
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.authorizationStatus = self.locationManager.authorizationStatus
        self.startUpdating()

    #if targetEnvironment(simulator)
        self.current = CLLocation(latitude: 40.652005801809445, longitude: -73.94718932404285)
        self.currentHeading = 6.162876129150391
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
//        let bathrooms = BathroomAttendant.shared.defaults.filter({ $0.lat == nil && $0.long == nil})
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
//            for bathroom in BathroomAttendant.shared.defaults {
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
        var bathrooms = BathroomAttendant.shared.defaults
        for i in 0..<bathrooms.count {
            var bathroom = bathrooms[i]
            
            if let current = self.current {
                let location = CLLocation(latitude: bathroom.coordinate.latitude, longitude: bathroom.coordinate.longitude)
                let distance = location.distance(from: current)
                
                let distanceMeters = Measurement(value: distance, unit: UnitLength.meters)
                let distanceMiles = distanceMeters.converted(to: .miles)
                let distanceFeet = distanceMeters.converted(to: .feet)
                let useMiles = (distanceMiles.value >= 0.25)
                bathroom.distance = useMiles ? distanceMiles.value : distanceFeet.value
                bathroom.distanceMeters = distanceMeters.value
                
                if var distance = bathroom.distance {
                    distance = useMiles ? round(distance * 10) / 10.0 : round(distance)
                    let travelTime = distance.travelTime
                    bathroom.distanceAway = "\(distance) \(useMiles ? "Miles" : "Feet") (\(travelTime) minutes) Away"
                }
                
                bathrooms[i] = bathroom
            }
        }
        
        BathroomAttendant.shared.changeDefaults(bathrooms.sorted(by: { $0.distance ?? 1000 < $1.distance ?? 1000 }))
    }
    
    func getDirections(to toId: Int) {
        if let current = self.current, var bathroom = BathroomAttendant.shared.defaults.first(where: { $0.id == toId }) {
                self.getTravelDirections(sourceLocation: current.coordinate, endLocation: bathroom.coordinate) { directions, route in
                        bathroom.directions = directions
                        bathroom.route = route
                        BathroomAttendant.shared.changeDefault(toId, to: bathroom)
                }
            }
    }
    
    func getHeadings() {
        var bathrooms = BathroomAttendant.shared.defaults
        for i in 0..<bathrooms.count {
            var bathroom = bathrooms[i]
            
            if let current = self.current {
                bathroom.heading = self.currentHeading.angle(current.coordinate, bathroom.coordinate)
                bathrooms[i] = bathroom
            }
        }
        
        BathroomAttendant.shared.defaults = bathrooms
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
    
    func getDistance(sourceLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D, completion: @escaping (_ distance: Double?, _ travelTime : String?) -> (Void)){
        let request = MKDirections.Request()
        let source = MKPlacemark( coordinate: sourceLocation)
        let destination = MKPlacemark( coordinate: endLocation)
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = true
        let directions = MKDirections ( request: request)
        directions.calculate { (response, error) in
            if let error = error {
                print("Distance directions calculation error\n \(error.localizedDescription)")
                return
            }
            if let routes = response?.routes, let shortestRoute = routes.sorted(by: { $0.distance < $1.distance}).first {
                completion(shortestRoute.distance, shortestRoute.expectedTravelTime.description)
            }
        }
    }
    
    func getTravelDirections(sourceLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D, completion: @escaping (_ directions: [String], _ route: MKRoute?) -> (Void)){
        let request = MKDirections.Request()
        let source = MKPlacemark( coordinate: sourceLocation)
        let destination = MKPlacemark( coordinate: endLocation)
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = true
        let directions = MKDirections ( request: request)
        directions.calculate { (response, error) in
            if let error = error {
                print("Distance directions calculation error\n \(error.localizedDescription)")
                return
            }
            if let routes = response?.routes, let shortestRoute = routes.sorted(by: { $0.distance < $1.distance}).first {
                let steps = shortestRoute.steps
                
                let directionSteps: [String] = steps.map { step in
                    guard let blocks = step.blocks else { return step.instructions }
                    let blockString = "\(blocks > 0 ? ("About \(blocks) blocks later, ") : "")"
                    let stepsString = "About \(step.distance.steps) steps later, "
                    let useSteps = step == steps.last
                    let introString = useSteps ? stepsString : blockString
                    
                    return "\(introString)\(step.instructions)"
                }
                
                completion(directionSteps, shortestRoute)
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
        
        if getFirst, let first = BathroomAttendant.shared.defaults.first {
            self.getDirections(to: first.id)
            self.getFirst = false
        }
        
        self.getDistances()
        self.objectWillChange.send()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentHeading = newHeading.trueHeading

        self.getHeadings()
        self.objectWillChange.send()
    }
}
