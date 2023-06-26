//
//  CLLocationDirection+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation
import MapKit

extension CLLocationDirection {
    var compassRepresentation: String {
        var normalizedDirection = self.truncatingRemainder(dividingBy: 360)
        
        if normalizedDirection < 0 {
            normalizedDirection = normalizedDirection + 360
        }
        
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        
        let index = Int((normalizedDirection + 11.25) / 22.5) % 16
        
        return directions[index]
    }
}
