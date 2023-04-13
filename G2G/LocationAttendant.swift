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
    
    @Published var currentHourValue: Double = 8.0
    
    var locationService = LocationService()
    
    private var getFirst = true
    
    override init() {
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
    
    func gradientForCurrentTime() -> LinearGradient? {
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
                
        if let location = current, let solar = Solar(coordinate: location.coordinate), let sunset = solar.sunset, let sunrise = solar.sunrise  {
            let sunsetHour = calendar.component(.hour, from: sunset)
            let sunriseHour = calendar.component(.hour, from: sunrise)
            if sunsetHour == currentHour {
                return Gradient.skyGradient19
            } else if sunriseHour == currentHour {
                return Gradient.skyGradient6
            } else if currentHour < sunriseHour {
                let difference = sunriseHour - currentHour
                let gradientMapped = 6 - difference
                if gradientMapped >= 0 {
                    return gradient(forHour: gradientMapped)
                } else {
                    let wrappedMapped = 24 + gradientMapped
                    return gradient(forHour: wrappedMapped)
                }
            } else if currentHour > sunriseHour && currentHour < sunsetHour {
                let difference = sunsetHour - currentHour
                let gradientMapped = 19 - difference
                if gradientMapped >= 6 {
                    return gradient(forHour: gradientMapped)
                } else {
                    let wrappedMapped = 24 - gradientMapped
                    return gradient(forHour: wrappedMapped)
                }
            } else if currentHour > sunsetHour {
                let difference = currentHour - sunsetHour
                let gradientMapped = 19 + difference
                if gradientMapped <= 23 {
                    return gradient(forHour: gradientMapped)
                } else {
                    let wrappedMapped = gradientMapped - 24
                    return gradient(forHour: wrappedMapped)
                }
            }
        }
        return gradient(forHour: currentHour)
    }
    
    private func gradient(forHour: Int) -> LinearGradient {
        switch forHour {
        case 0: return Gradient.skyGradient0
        case 1: return Gradient.skyGradient1
        case 2: return Gradient.skyGradient2
        case 3: return Gradient.skyGradient3
        case 4: return Gradient.skyGradient4
        case 5: return Gradient.skyGradient5
            //Sunrise
        case 6: return Gradient.skyGradient6
        case 7: return Gradient.skyGradient7
        case 8: return Gradient.skyGradient8
        case 9: return Gradient.skyGradient9
        case 10: return Gradient.skyGradient10
        case 11: return Gradient.skyGradient11
        case 12: return Gradient.skyGradient12
        case 13: return Gradient.skyGradient13
        case 14: return Gradient.skyGradient14
        case 15: return Gradient.skyGradient15
        case 16: return Gradient.skyGradient16
        case 17: return Gradient.skyGradient17
        case 18: return Gradient.skyGradient18
            // Sunset
        case 19: return Gradient.skyGradient19
        case 20: return Gradient.skyGradient20
        case 21: return Gradient.skyGradient21
        case 22: return Gradient.skyGradient22
        case 23: return Gradient.skyGradient23
        default: return Gradient.skyGradient23
        }
    }
    
    func getDirections(to toId: Int) {
        if let current = self.current, let index = BathroomAttendant.shared.sortedBathrooms.firstIndex(where: {$0.id == toId}) {
            let bathroom = BathroomAttendant.shared.sortedBathrooms[index]
            self.getTravelDirections(sourceLocation: current.coordinate, endLocation: BathroomAttendant.shared.sortedBathrooms[index].coordinate) { directions, route in
                bathroom.directions = directions
                bathroom.route = route
                if let travelTime = route?.expectedTravelTime {
                    let travelMinutes = Int(travelTime/60)
                    bathroom.directionsEta = "\(travelMinutes) minute\(travelMinutes == 1 ? "" : "s")"
                }
                BathroomAttendant.shared.sortedBathrooms[index] = bathroom
            }
        }
    }
    
    
    func getHeadings() {
        for bathroom in BathroomAttendant.shared.sortedBathrooms {
            if let index = BathroomAttendant.shared.sortedBathrooms.firstIndex(where: {$0.id == bathroom.id}) {
                let bathroom = BathroomAttendant.shared.sortedBathrooms[index]
                if !bathroom.directions.isEmpty {
                    let firstStep = bathroom.directions[0]
                    bathroom.heading = firstStep.streetHeading
                }
                if let current = self.current {
                    bathroom.generalHeading = self.currentHeading.angle(current.coordinate, bathroom.coordinate)
                }
                BathroomAttendant.shared.sortedBathrooms[index] = bathroom
            }
        }
    }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocation?)-> Void) {
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
        request.requestsAlternateRoutes = true
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
        if self.selectedSearchLocation == nil {
            self.current = lastLocation            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentHeading = newHeading.trueHeading
        
        self.getHeadings()
    }
}
