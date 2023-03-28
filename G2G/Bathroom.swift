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

struct Bathroom: Identifiable, Equatable {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var comment: String?
    var code: String?
    var hours: Hours?
    var id: Int
    var distanceMeters: Double?
    var distance: Double?
    var distanceAway: String?
    var heading: Double = 0.0
    var directions: [String] = []
    var route: MKRoute?

    var annotation: Annotation? {
        return Annotation(title: name, coordinate: coordinate)
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, comment: String? = nil, code: String? = nil, hours: Hours? = nil, id: Int, distance: Double? = nil) {
        self.name = name
        self.address = address
        self.comment = comment
        self.code = code
        self.hours = hours
        self.id = id
        self.distance = distance
        self.coordinate = coordinate
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func ==(lhs: Bathroom, rhs: Bathroom) -> Bool {
        return (lhs.id == rhs.id && lhs.address == rhs.address)
    }
}

struct Hours: Codable, Hashable {
    var open: Date
    var close: Date
}
