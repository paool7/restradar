//
//  Bathroom.swift
//  G2G
//
//  Created by Paul Dippold on 3/18/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import TelemetryClient

enum Accessibility: String, Equatable {
    case full
    case partial
    case none
    case unknown
}

class Bathroom: Identifiable, Equatable, ObservableObject, Hashable {
    var code: String?
    var category: Category
    var address: String?
    var id: String
    var name: String
    var accessibility: Accessibility = .unknown
    var url: String?

    @Published var coordinate: CLLocationCoordinate2D
    @Published var directions: [MKRoute.Step] = []
    @Published var route: MKRoute?
    @Published var isClean: Rating {
        didSet {
            userDefaults?.setValue(isClean.boolValue, forKey: "\(id)-clean-rating")
            switch isClean {
            case .upvote:
                TelemetryManager.send("Clean-Upvote", with: ["rating": "1", "buid": id])
            case .downvote:
                TelemetryManager.send("Clean-Downvote", with: ["rating": "0", "buid": id])
            case .unknown:
                break
            }
        }
    }
    @Published var isAccessible: Rating {
        didSet {
            userDefaults?.setValue(isAccessible.boolValue, forKey: "\(id)-accessible-rating")
            switch isAccessible {
            case .upvote:
                TelemetryManager.send("Accessible-Upvote", with: ["rating": "1", "buid": id])
            case .downvote:
                TelemetryManager.send("Accessible-Downvote", with: ["rating": "0", "buid": id])
            case .unknown:
                break
            }
        }
    }

    init(name: String, accessibility: Accessibility, coordinate: CLLocationCoordinate2D, address: String? = nil, code: String? = nil, id: String, url: String?, category: Category) {
        self.name = name
        self.accessibility = accessibility
        self.address = address
        self.code = code
        self.id = id
        self.coordinate = coordinate
        self.url = url
        self.category = category
        
        if let cleanRating = userDefaults?.object(forKey: "\(id)-clean-rating") as? Bool {
            if cleanRating {
                self.isClean = .upvote
            } else {
                self.isClean = .downvote
            }
        } else {
            isClean = .unknown
        }
        
        if let accessibleRating = userDefaults?.object(forKey: "\(id)-accessible-rating") as? Bool {
            if accessibleRating {
                self.isAccessible = .upvote
            } else {
                self.isAccessible = .downvote
            }
        } else {
            isAccessible = .unknown
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func ==(lhs: Bathroom, rhs: Bathroom) -> Bool {
        return (lhs.id == rhs.id && lhs.directions == rhs.directions && lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude && lhs.isClean == rhs.isClean  && lhs.isAccessible == rhs.isAccessible && lhs.address == rhs.address)
    }
    
    var description : String {
        get {
            return """
            { "name": \"\(name)\", "id": "\(self.id)", "lat": \(self.coordinate.latitude.description), "lng": \(self.coordinate.longitude.description), "accessibility": \"\(accessibility.rawValue)\", "address": \"\(address ?? "")\", "url": \"\(url ?? "")\" },
            """
        }
    }
    
    func distanceString(withUnit: Bool = false) -> String? {
        switch SettingsAttendant.shared.distanceMeasurement {
        case .blocks:
            let blocks = blockEstimate() ?? 0
            return withUnit ? "\(blocks) \(blocks == 1 ? "block" : "blocks")" : "\(blocks)"
        case .steps:
            return withUnit ? self.stepsAway() : "\(self.totalSteps() ?? 0)"
        case .milesfeet:
            guard let distanceMiles = self.distance(unit: .miles),
                  let distanceFeet = self.distance(unit: .feet) else { return nil }
            
            let feetString = withUnit ? "\(Int(distanceFeet)) \(distanceFeet == 1.0 ? "foot" : "feet")" : "\(Int(distanceFeet))"
            let milesString = withUnit ? (distanceMiles == 1.0 ? "1 mile" : "\(String(format: "%.1f", distanceMiles)) miles") : "\(String(format: "%.1f", distanceMiles))"
            if distanceMiles > 1.0 {
                return milesString
            } else {
                if distanceFeet <= 500 {
                    return feetString
                } else {
                    let milesRational = Rational(approximating: distanceMiles, withPrecision: 0.1)
                    return withUnit ? "\(milesRational.numerator)/\(milesRational.denominator) mile" : "\(milesRational.numerator)/\(milesRational.denominator)"
                }
            }
        case .meterskilometers:
            guard let distanceKilometers = self.distance(unit: .kilometers),
                  let distanceMeters = self.distance(unit: .meters) else { return nil }
            
            let metersString = withUnit ? "\(Int(distanceMeters)) \(distanceMeters == 1.0 ? "meter" : "meters")" : "\(Int(distanceMeters))"
            let kilometerString = withUnit ? (distanceKilometers == 1.0 ? "1 km" : "\(String(format: "%.1f", distanceKilometers)) kms") : "\(String(format: "%.1f", distanceKilometers))"
            if distanceKilometers > 1.0 {
                return kilometerString
            } else {
                if distanceMeters <= 500 {
                    return metersString
                } else {
                    let milesRational = Rational(approximating: distanceKilometers, withPrecision: 0.1)
                    return withUnit ? "\(milesRational.numerator)/\(milesRational.denominator) km" : "\(milesRational.numerator)/\(milesRational.denominator)"
                }
            }
        }
    }
    
    func getDirections() {
        if let current = LocationAttendant.shared.current, self.directions.isEmpty {
            LocationAttendant.shared.getTravelDirections(sourceLocation: current.coordinate, endLocation: self.coordinate) { directions, route in
                self.directions = directions
                self.route = route

                if let index = BathroomAttendant.shared.allBathrooms.firstIndex(of: self) {
                    BathroomAttendant.shared.allBathrooms[index] = self
                }
            }
        }
    }
    
    func getDirections() async throws -> Bool {
        guard let current = LocationAttendant.shared.current else { return false }
        
        do {
            let result = try await LocationAttendant.shared.getTravelDirections(sourceLocation: current.coordinate, endLocation: self.coordinate)
            self.directions = result.directions
            self.route = result.route

            return true
        } catch {
            return false
        }
    }
    
    func imageFor(step: MKRoute.Step) -> String {
        let isFirst = step == directions.first
        let isLast = step == directions.last
        var imageName = "door.left.hand.open"
        if isLast {
            imageName = step.instructions.lowercased().contains("on your right") ? "door.sliding.right.hand.open" : (step.instructions.lowercased().contains("on your left") ? "door.sliding.left.hand.open" : "mappin")
        } else if !isFirst {
            imageName = step.instructions.lowercased().contains("take a right") ? "arrow.turn.up.right" : (step.instructions.lowercased().contains("take a left") ? "arrow.turn.up.left" : SettingsAttendant.shared.transportMode.imageString)
        }
        return imageName
    }
    
    func summaryFor(step: MKRoute.Step) -> String {
        let isFirst = step == directions.first
        let isLast = step == directions.last
        var summary = "Walk"
        if isLast {
            summary = "Arrive"
        } else if !isFirst {
            summary = step.instructions.lowercased().contains("take a right") ? "Right" : (step.instructions.lowercased().contains("take a left") ? "Left" : "Walk")
        }
        return summary
    }

    var annotation: Annotation? {
        return Annotation(title: name, coordinate: coordinate)
    }
    
    func distance(unit: UnitLength) -> Double? {
        guard let distanceMeters = distanceMeters() else { return nil }
        let convertedDistance = distanceMeters.converted(to: unit)
        
        return convertedDistance.value
    }
    
    func distanceMeters() -> Measurement<UnitLength>? {
        guard let current = LocationAttendant.shared.current else { return nil }

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let locationDistance = location.distance(from: current)
        
        return Measurement(value: locationDistance, unit: .meters)
    }
    
    func totalTime() -> Int? {
        guard let current = LocationAttendant.shared.current else { return nil }

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let locationDistance = location.distance(from: current)
        
        return locationDistance.travelTime
    }
    
    func totalSteps() -> Int? {
        guard let distanceMeters = distanceMeters() else { return nil }
        return distanceMeters.value.steps
    }
    
    func stepsAway() -> String? {
        guard let distanceMeters = distanceMeters() else { return nil }

        return "~\(distanceMeters.value.steps) step\(distanceMeters.value.steps == 1 ? "" : "s")"
    }
    
    var totalBlocks: Int {
        var total = 0
        for i in 0..<directions.count {
            let step = directions[i]
            if i >= self.currentRouteStepIndex, let blocks = step.blocks {
                total += blocks
            }
        }
        return total
    }
    
    func blockEstimate() -> Int? {
        guard let distanceMeters = distanceMeters() else { return nil }
        
        let distanceFeet = distanceMeters.converted(to: .feet)
        return Int(distanceFeet.value/375.0)
    }
    
    func currentRouteStep() -> MKRoute.Step? {
        guard let route = self.route, let current = LocationAttendant.shared.current else { return nil }
        
        let currentRect = MKCircle(center: current.coordinate, radius: 6.0).boundingMapRect
        
        for step in route.steps {
            let line = step.polyline
            
            if line.intersects(currentRect) {
                return step
            }
        }
        
        return nil
    }
    
    func indexFor(step: MKRoute.Step) -> Int? {
        return directions.firstIndex(where: {$0.instructions == step.instructions})
    }
    
    var currentRouteStepIndex: Int {
        guard let currentStep = self.currentRouteStep() else { return 0 }
        
        return self.directions.firstIndex(of: currentStep) ?? 0
    }
}
