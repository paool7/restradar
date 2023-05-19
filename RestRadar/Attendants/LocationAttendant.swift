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
import Solar

class LocationAttendant: NSObject, ObservableObject {
    static var shared = LocationAttendant()
    
    let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    @Published var selectedSearchLocation: MKLocalSearchCompletion?

    @Published var current: CLLocation?
    @Published var currentHeading: CLLocationDegrees = 0.0
    
    @Published var currentHourValue: Double
    
    var locationService = LocationService()
    
    private var getFirst = true
    
    override init() {
        let date = Date()
        let calendar = Calendar.current
        currentHourValue = Double(calendar.component(.hour, from: date))
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.authorizationStatus = self.locationManager.authorizationStatus
        self.startUpdating()

    #if targetEnvironment(simulator)
        self.current = CLLocation(latitude: 40.652005801809445, longitude: -73.94718932404285)
        self.currentHeading = -12.0 //6.162876129150391
    #endif
    }
    
    public func requestAuthorization() {
        if self.authorizationStatus == .authorizedWhenInUse {
            self.startUpdating()
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
    
    func getDirections(to toId: String) {
        if let current = self.current, let index = BathroomAttendant.shared.allBathrooms.firstIndex(where: {$0.id == toId}) {
            let bathroom = BathroomAttendant.shared.allBathrooms[index]
            self.getTravelDirections(sourceLocation: current.coordinate, endLocation: BathroomAttendant.shared.allBathrooms[index].coordinate) { directions, route in
                bathroom.directions = directions
                bathroom.route = route
                if let travelTime = route?.expectedTravelTime {
                    let travelMinutes = Int(travelTime/60)
                    bathroom.directionsEta = "\(travelMinutes) minute\(travelMinutes == 1 ? "" : "s")"
                }
                BathroomAttendant.shared.allBathrooms[index] = bathroom
            }
        }
    }
    
    func getDirections(toId: String) async throws -> Bathroom? {
        if let current = self.current, let index = BathroomAttendant.shared.allBathrooms.firstIndex(where: {$0.id == toId}) {
            let bathroom = BathroomAttendant.shared.allBathrooms[index]
            do {
                let result = try await self.getTravelDirections(sourceLocation: current.coordinate, endLocation: BathroomAttendant.shared.allBathrooms[index].coordinate)
                bathroom.directions = result.directions
                bathroom.route = result.route
                if let travelTime = result.route?.expectedTravelTime {
                        let travelMinutes = Int(travelTime/60)
                        bathroom.directionsEta = "\(travelMinutes) minute\(travelMinutes == 1 ? "" : "s")"
                }
                BathroomAttendant.shared.allBathrooms[index] = bathroom
                return bathroom
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocation?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location else {
                completion(nil)
                return
            }
            
            if let error = error {
                print(error)
            }
            completion(location)
        }
    }
    
    func getTravelDirections(sourceLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) async throws ->  (directions: [MKRoute.Step], route: MKRoute?) {
        let request = MKDirections.Request()
        let source = MKPlacemark( coordinate: sourceLocation)
        let destination = MKPlacemark( coordinate: endLocation)
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = true
        let directions = MKDirections (request: request)
        
        do {
            let directions = try await directions.calculate()
            let routes = directions.routes
            if let shortestRoute = routes.sorted(by: { $0.expectedTravelTime < $1.expectedTravelTime}).first {
                return (shortestRoute.steps, shortestRoute)
            } else {
                return ([], nil)
            }
        } catch {
            print("Distance directions calculation error\n \(error.localizedDescription)")
            return ([], nil)
        }
    }
    
    func getTravelDirections(sourceLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D, completion: @escaping (_ directions: [MKRoute.Step], _ route: MKRoute?) -> (Void)) {
        let request = MKDirections.Request()
        let source = MKPlacemark( coordinate: sourceLocation)
        let destination = MKPlacemark( coordinate: endLocation)
        request.source =  MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = true
        let directions = MKDirections (request: request)
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
    
    func fetchLocation() async throws -> CLLocation {
        self.locationManager.requestLocation()
        while self.current == nil && self.currentHeading == 0.0 {
            
        }
        return current!
    }
}

extension LocationAttendant: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        self.startUpdating()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        if self.selectedSearchLocation == nil {
            self.current = lastLocation            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentHeading = newHeading.trueHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:\(error)")
    }
}
