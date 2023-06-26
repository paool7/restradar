//
//  BinaryFloatingPoint+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation

extension BinaryFloatingPoint {
    var radians: Self {
        return self * .pi / 180
    }
    
    var degrees: Self {
        return self * 180 / .pi
    }
}
