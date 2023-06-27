//
//  MKRouteStep+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/25/23.
//

import Foundation
import MapKit

extension MKRoute.Step {
    func naturalCurrentInstruction() -> String? {
        guard let blocks = self.blocksLeft(), let distanceLeft = self.distanceLeft() else { return self.instructions }
        let naturalStart = "\(blocks > 0 ? ("In \(blocks) block\(distanceLeft.blocksPostFix), ") : (distanceLeft.steps > 10 ? "In \(distanceLeft.steps) step\(distanceLeft.stepsPostFix), " : ""))"
        
        return "\(naturalStart)\(self.instructions)"
    }
    
    var naturalInstructions: String? {
        guard let blocks = self.blocks else { return self.instructions }
        let naturalStart = "\(blocks > 0 ? ("\(blocks) block\(blocks == 1 ? "" : "s") later, ") : (self.distance.steps > 10 ? "\(self.distance.steps) step\(self.distance.steps == 1 ? "" : "s") later, " : self.instructions))"
        
        return "\(naturalStart)\(self.instructions)"
    }
    
    func naturalCurrentIntro() -> String? {
        guard let blocks = self.blocksLeft(), let distanceLeft = self.distanceLeft() else { return self.instructions }
        return "\(blocks > 0 ? ("In \(blocks) block\(distanceLeft.blocksPostFix), ") : (distanceLeft.steps > 10 ? "In \(distanceLeft.steps) step\(distanceLeft.stepsPostFix), " : " "))"
    }
    
    func naturalSummaryIntro() -> String? {
        guard let blocks = self.blocksLeft(), let distanceLeft = self.distanceLeft() else { return self.instructions }
        return "\(blocks > 0 ? ("In \(blocks) block\(distanceLeft.blocksPostFix)...") : (distanceLeft.steps > 10 ? "In \(distanceLeft.steps) step\(distanceLeft.stepsPostFix)..." : self.instructions))"
    }
    
    var blocks: Int? {
        if let direction = self.direction {
            let blockWidth = direction.blockWidth
            let distanceMeters = Measurement(value: self.distance, unit: UnitLength.meters)
            let distanceFeet = distanceMeters.converted(to: .feet)
            return Int(distanceFeet.value / blockWidth)
        }
        
        return nil
    }
    
    func blocksLeft() -> Int? {
        guard let current = LocationAttendant.shared.current else { return nil }

        if let direction = self.direction, let lastLat = self.coordinates.1?.latitude, let lastLong = self.coordinates.1?.longitude {
            let blockWidth = direction.blockWidth
            let distanceLeft = current.distance(from: CLLocation(latitude: lastLat, longitude: lastLong))
            let distanceMeters = Measurement(value: distanceLeft, unit: UnitLength.meters)
            let distanceFeet = distanceMeters.converted(to: .feet)
            return Int(distanceFeet.value / blockWidth)
        }
        
        return nil
    }
    
    func distanceLeft() -> CLLocationDistance? {
        guard let current = LocationAttendant.shared.current else { return nil }

        if let lastLat = self.coordinates.1?.latitude, let lastLong = self.coordinates.1?.longitude {
            return CLLocation(latitude: lastLat, longitude: lastLong).distance(from: current)
        }
        
        return nil
    }
    
    var direction: StepDirection? {
        return DirectionRange.stepDirection(self.streetHeading)
    }
    
    var coordinates: (CLLocationCoordinate2D?, CLLocationCoordinate2D?) {
        var firstCoordinate: CLLocationCoordinate2D?
        var lastCoordiante: CLLocationCoordinate2D?

        for point in UnsafeBufferPointer(start: self.polyline.points(), count: self.polyline.pointCount) {
            if firstCoordinate == nil {
                firstCoordinate = point.coordinate
            }
            lastCoordiante = point.coordinate
        }
        
        return(firstCoordinate, lastCoordiante)
    }
    
    var streetHeading: Double {
        var firstCoordinate: CLLocationCoordinate2D?
        var lastCoordinate: CLLocationCoordinate2D?

        for point in UnsafeBufferPointer(start: self.polyline.points(), count: self.polyline.pointCount) {
            if firstCoordinate == nil {
                firstCoordinate = point.coordinate
            }
            lastCoordinate = point.coordinate
        }

        if let firstCoordinate = firstCoordinate, let lastCoordinate = lastCoordinate {
            return firstCoordinate.angle(lastCoordinate)
        }
        
        return 0.0
    }
    
    func relativeHeading(currentHeading: CLLocationDegrees) -> Double {
        var firstCoordinate: CLLocationCoordinate2D?
        var lastCoordiante: CLLocationCoordinate2D?

        for point in UnsafeBufferPointer(start: self.polyline.points(), count: self.polyline.pointCount) {
            if firstCoordinate == nil {
                firstCoordinate = point.coordinate
            }
            lastCoordiante = point.coordinate
        }

        if let firstCoordinate = firstCoordinate, let lastCoordiante = lastCoordiante {
            return firstCoordinate.angle(lastCoordiante)
        }
        
        return 0.0
    }
}
