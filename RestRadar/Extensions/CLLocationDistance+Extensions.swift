//
//  CLLocationDistance+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation
import MapKit

extension CLLocationDistance {
    var feet: Double {
        let distanceMeters = Measurement(value: self, unit: UnitLength.meters)
        let distanceFeet = distanceMeters.converted(to: .feet)
        return distanceFeet.value
    }
    
    var miles: Double {
        let distanceMeters = Measurement(value: self, unit: UnitLength.meters)
        let distanceMiles = distanceMeters.converted(to: .miles)
        return distanceMiles.value
    }
    
    var stepsPostFix: String {
        switch steps {
        case 1:
            return ""
        default:
            return "s"
        }
    }
    
    var blocksPostFix: String {
        switch blocks {
        case 1:
            return ""
        default:
            return "s"
        }
    }
    
    var steps: Int {
        let distanceMeters = Measurement(value: self, unit: UnitLength.meters)
        let distanceFeet = distanceMeters.converted(to: .feet)
        return Int(distanceFeet.value / SettingsAttendant.shared.stepLength)
    }
    
    var avenueBlocks: Int {
        let distanceMeters = Measurement(value: self, unit: UnitLength.meters)
        let distanceFeet = distanceMeters.converted(to: .feet)
        return Int(distanceFeet.value / StepDirection.west.blockWidth)
    }
    
    var blocks: Int {
        let distanceMeters = Measurement(value: self, unit: UnitLength.meters)
        let distanceFeet = distanceMeters.converted(to: .feet)
        return Int(distanceFeet.value / StepDirection.north.blockWidth)
    }
    
    var travelTime: Int {
        let distanceMeters = Measurement(value: self, unit: UnitLength.meters)
        let distanceMiles = distanceMeters.converted(to: .miles)
        let speed = SettingsAttendant.shared.transportMode == .walking ? SettingsAttendant.shared.walkingSpeed : (SettingsAttendant.shared.useElectricWheelchair ? SettingsAttendant.shared.electricWheelchairSpeed : SettingsAttendant.shared.wheelchairSpeed)
        let hours = distanceMiles.value/speed
        let minutes = hours*60
        return Int(minutes)
    }
}
