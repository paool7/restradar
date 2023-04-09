//
//  Extensions.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func midpointTo(location:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lon1 = longitude * .pi / 180
        let lon2 = location.longitude * .pi / 180
        let lat1 = latitude * .pi / 180
        let lat2 = location.latitude * .pi / 180
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)

        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
        let lon3 = lon1 + atan2(y, cos(lat1) + x)

        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / .pi, lon3 * 180 / .pi)
        return center
    }

    ///Check if the `coordinate` is within the `MKCoordinateRegion`
    func isWithinRegion(region: MKCoordinateRegion) -> Bool{
        var result = false
        //Get the upper and lower bounds of the latitude and longitude
        //center +/- span/2
        //divide by 2 because the center is half way through
        let latUpper = region.center.latitude + region.span.latitudeDelta/2
        let latLower = region.center.latitude - region.span.latitudeDelta/2
        let lonUpper = region.center.longitude + region.span.longitudeDelta/2
        let lonLower = region.center.longitude - region.span.longitudeDelta/2
        //If the coordinate is within the latitude and the longitude
        if self.latitude >= latLower && self.latitude <= latUpper{
            if self.longitude >= lonLower && self.longitude <= lonUpper{
                //It is within the region
                result = true
            }
        }
        
        return result
    }
}

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
        return Int(distanceFeet.value / 2.5)
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
        let hours = distanceMiles.value/3.0
        let minutes = hours*60
        return Int(minutes)
    }
}

extension BinaryFloatingPoint {
    var radians: Self {
        return self * .pi / 180
    }
    
    var degrees: Self {
        return self * 180 / .pi
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension CLLocationCoordinate2D {
    func getBearing(to: CLLocationCoordinate2D) -> Double {
        let lat1 = self.latitude.radians
        let lon1 = self.longitude.radians
        
        let lat2 = to.latitude.radians
        let lon2 = to.longitude.radians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        // TODO: Decide on radians
        let radiansBearing = atan2(y, x)
//        if radiansBearing < 0 {
//            radiansBearing += 2 * Double.pi
//        }
        return radiansBearing.degrees
    }
}

extension CLLocationDirection {
    /// Compute the angle between two map points and the from point heading
    /// returned angle is between 0 and 360 degrees
    func angle(_ fromPoint: CLLocationCoordinate2D, _ toPoint: CLLocationCoordinate2D) -> CLLocationDirection {
        let bearing = fromPoint.getBearing(to: toPoint)
        return bearing - self
    }
}

extension MKRoute.Step {
    var blocks: Int? {
        if let direction = self.direction {
            let blockWidth = direction.blockWidth
            let distanceMeters = Measurement(value: self.distance, unit: UnitLength.meters)
            let distanceFeet = distanceMeters.converted(to: .feet)
            return Int(distanceFeet.value / blockWidth)
        }
        
        return nil
    }
    
    var blocksLeft: Int? {
        if let direction = self.direction, let current = LocationAttendant.shared.current, let lastLat = self.coordinates.1?.latitude, let lastLong = self.coordinates.1?.longitude {
            let blockWidth = direction.blockWidth
            let distanceLeft = current.distance(from: CLLocation(latitude: lastLat, longitude: lastLong))
            let distanceMeters = Measurement(value: distanceLeft, unit: UnitLength.meters)
            let distanceFeet = distanceMeters.converted(to: .feet)
//            print("Distance: \(distanceFeet)")
            return Int(distanceFeet.value / blockWidth)
        }
        
        return nil
    }
    
    var distanceLeft: CLLocationDistance? {
        if let current = LocationAttendant.shared.current, let lastLat = self.coordinates.1?.latitude, let lastLong = self.coordinates.1?.longitude {
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
        var lastCoordiante: CLLocationCoordinate2D?

        for point in UnsafeBufferPointer(start: self.polyline.points(), count: self.polyline.pointCount) {
            if firstCoordinate == nil {
                firstCoordinate = point.coordinate
            }
            lastCoordiante = point.coordinate
        }

        if let firstCoordinate = firstCoordinate, let lastCoordiante = lastCoordiante {
            return CLLocationDirection(0.0).angle(firstCoordinate, lastCoordiante)
        }
        
        return 0.0
    }
    
    var relativeHeading: Double {
        var firstCoordinate: CLLocationCoordinate2D?
        var lastCoordiante: CLLocationCoordinate2D?

        for point in UnsafeBufferPointer(start: self.polyline.points(), count: self.polyline.pointCount) {
            if firstCoordinate == nil {
                firstCoordinate = point.coordinate
            }
            lastCoordiante = point.coordinate
        }

        if let firstCoordinate = firstCoordinate, let lastCoordiante = lastCoordiante {
            return LocationAttendant.shared.currentHeading.angle(firstCoordinate, lastCoordiante)
        }
        
        return 0.0
    }
}

enum DirectionRange {
    static let lowerNorthRange = 0.0...44.9999
    static let upperNorthRange = 315.0...359.999
    static let eastRange = 45.0...134.9999
    static let southRange = 135.0...224.999
    static let westRange = 225.0...315.999
    case outOfRange
    
    static func stepDirection(_ value: Double) -> StepDirection {
        switch value {
        case DirectionRange.lowerNorthRange, DirectionRange.upperNorthRange:
            return .north
        case DirectionRange.eastRange:
            return .east
        case DirectionRange.southRange:
            return .south
        case DirectionRange.westRange:
            return .west
        default:
            return .north
        }
    }
}

enum StepDirection {
    case north
    case east
    case south
    case west
    
    var blockWidth: Double {
        switch self {
        case .north, .south:
            return 375.0
        case .east, .west:
            return 750.0
        }
    }
}
