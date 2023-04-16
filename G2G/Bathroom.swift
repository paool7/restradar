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

extension MKRoute.Step {
    func naturalCurrentInstruction() -> String? {
        guard let current = LocationAttendant.shared.current, let blocks = self.blocksLeft(current: current), let distanceLeft = self.distanceLeft(current: current) else { return self.instructions }
        let naturalStart = "\(blocks > 0 ? ("In \(blocks) block\(distanceLeft.blocksPostFix), ") : (distanceLeft.steps > 10 ? "In \(distanceLeft.steps) step\(distanceLeft.stepsPostFix), " : ""))"
        
        return "\(naturalStart)\(self.instructions)"
    }
    
    var naturalInstructions: String? {
        guard let blocks = self.blocks else { return self.instructions }
        let naturalStart = "\(blocks > 0 ? ("\(blocks) block\(blocks == 1 ? "" : "s") later, ") : (self.distance.steps > 10 ? "\(self.distance.steps) step\(self.distance.steps == 1 ? "" : "s") later, " : ""))"
        
        return "\(naturalStart)\(self.instructions)"
    }
    
    func naturalCurrentIntro() -> String? {
        guard let current = LocationAttendant.shared.current, let blocks = self.blocksLeft(current: current), let distanceLeft = self.distanceLeft(current: current) else { return self.instructions }
        return "\(blocks > 0 ? ("In \(blocks) block\(distanceLeft.blocksPostFix)") : (distanceLeft.steps > 10 ? "In \(distanceLeft.steps) step\(distanceLeft.stepsPostFix)" : " "))"
    }
}

class Bathroom: Identifiable, Equatable, ObservableObject {
    var address: String
    var code: String?
    var comment: String?
    var hours: Hours?
    var id: String
    var name: String
    
    @Published var coordinate: CLLocationCoordinate2D
    @Published var directions: [MKRoute.Step] = []
    @Published var directionsEta: String?
    @Published var generalHeading: Double = 0.0
    @Published var heading: Double = 0.0
    @Published var route: MKRoute?
    
    func imageFor(step: MKRoute.Step) -> String {
        let isFirst = step == directions.first
        let isLast = step == directions.last
        var imageName = "figure.walk"
        if isLast {
            imageName = step.instructions.lowercased().contains("on your right") ? "signpost.right" : (step.instructions.lowercased().contains("on your left") ? "signpost.left" : "mappin")
        } else if !isFirst {
            imageName = step.instructions.lowercased().contains("take a right") ? "arrow.turn.up.right" : (step.instructions.lowercased().contains("take a left") ? "arrow.turn.up.left" : "figure.walk")
        }
        return imageName
    }
        
    func heading(current: CLLocation) -> Double {
        if let firstStep = directions.first {
            return firstStep.streetHeading
        }
        return 0.0
    }

    func generalHeading(current: CLLocation, currentHeading: CLLocationDirection) -> Double {
        return currentHeading.angle(current.coordinate, coordinate)
    }

    var annotation: Annotation? {
        return Annotation(title: name, coordinate: coordinate)
    }
    
    func distanceMeters(current: CLLocation) -> Measurement<UnitLength>? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let locationDistance = location.distance(from: current)
        
        return Measurement(value: locationDistance, unit: UnitLength.meters)
    }
    
    func totalTime(current: CLLocation) -> Int {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let locationDistance = location.distance(from: current)
        
        return locationDistance.travelTime
    }
    
    func timeAway(current: CLLocation) -> String? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let locationDistance = location.distance(from: current)
        
        return "\(locationDistance.travelTime) minute\(locationDistance.travelTime == 1 ? "" : "s")"
    }
    
    func distanceAway(current: CLLocation) -> String? {
        guard let distanceMeters = distanceMeters(current: current) else { return nil }
        let distanceMiles = distanceMeters.converted(to: .miles)
        let distanceFeet = distanceMeters.converted(to: .feet)
        let useMiles = (distanceMiles.value >= 0.25)
        let distance = useMiles ? round(distanceMiles.value * 10) / 10.0 : round(distanceFeet.value)
        
        return "\(distance) \(useMiles ? "Miles" : "Feet")"
    }
    
    func totalSteps(current: CLLocation) -> Int? {
        guard let distanceMeters = distanceMeters(current: current) else { return nil }
        return distanceMeters.value.steps
    }
    
    func stepsAway(current: CLLocation) -> String? {
        guard let distanceMeters = distanceMeters(current: current) else { return nil }
        return "~\(distanceMeters.value.steps) step\(distanceMeters.value.steps == 1 ? "" : "s")"
    }
    
    var totalBlocks: Int {
        var total = 0
        for step in directions {
            if let blocks = step.blocks {
                total += blocks
            }
        }
        return total
    }
    
    var blocksAway: String {
        var total = 0
        for step in directions {
            if let blocks = step.blocks {
                total += blocks
            }
        }
        return "\(total > 0 ? ("\(total) block\(total == 1 ? "" : "s")") : "")"
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
    
    var currentRouteStepIndex: Int? {
        guard let route = self.route, let current = LocationAttendant.shared.current else { return nil }
        
        let currentRect = MKCircle(center: current.coordinate, radius: 6.0).boundingMapRect
        
        for step in route.steps {
            let line = step.polyline
            
            if line.intersects(currentRect), let index = directions.firstIndex(where: {$0.instructions == step.instructions}) {
                return index
            }
        }
        
        return nil
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, comment: String? = nil, code: String? = nil, hours: Hours? = nil, id: String) {
        self.name = name
        self.address = address
        self.comment = comment
        self.code = code
        self.hours = hours
        self.id = id
        self.coordinate = coordinate
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func ==(lhs: Bathroom, rhs: Bathroom) -> Bool {
        return (lhs.id == rhs.id && lhs.address == rhs.address && lhs.directions == rhs.directions && lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude && lhs.hours == rhs.hours && lhs.comment == rhs.comment)
    }
}

struct Hours: Codable, Hashable {
    var open: Date
    var close: Date
}
