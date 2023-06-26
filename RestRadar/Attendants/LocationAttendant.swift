//
//  LocationAttendant.swift
//  G2G
//
//  Created by Paul Dippold on 3/19/23.
//

import CoreLocation
import Foundation
import MapKit
import Solar
import SwiftUI
import TelemetryClient

class LocationAttendant: NSObject, ObservableObject {
    static var shared = LocationAttendant()
    
    let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    @Published var selectedSearchLocation: MKLocalSearchCompletion?

    @Published var current: CLLocation?
    @Published var currentHeading: CLLocationDegrees?
    
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
                TelemetryManager.send("Error", with: ["type": "GetLocation", "message": error.localizedDescription])
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
            TelemetryManager.send("Error", with: ["type": "CalculateDirectionsAsync", "message": error.localizedDescription])
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
                TelemetryManager.send("Error", with: ["type": "CalculateDirections", "message": error.localizedDescription])
                return
            }
            if let routes = response?.routes, let shortestRoute = routes.sorted(by: { $0.expectedTravelTime < $1.expectedTravelTime}).first {
                completion(shortestRoute.steps, shortestRoute)
            }
        }
    }
    
    func fetchLocation() async throws -> CLLocation {
        self.locationManager.requestLocation()
        while self.current == nil && self.currentHeading == nil { }
        return current!
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
        TelemetryManager.send("Error", with: ["type": "LocationManager", "message": error.localizedDescription])
    }
    
}
