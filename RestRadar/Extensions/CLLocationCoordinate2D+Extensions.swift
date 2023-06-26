//
//  CLLocationCoordinate2D+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation
import MapKit

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
    
    /// Compute the angle between two map points and the from point heading
    /// returned angle is between 0 and 360 degrees
    func angle(_ toPoint: CLLocationCoordinate2D) -> CLLocationDirection {
        return self.getBearing(to: toPoint)
    }
    
    /// Compute the angle between two map points and the from point heading
    /// returned angle is between 0 and 360 degrees
    func angle(_ toPoint: CLLocationCoordinate2D, offset: Double) -> CLLocationDirection {
        return self.getBearing(to: toPoint) - offset
    }
    
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
