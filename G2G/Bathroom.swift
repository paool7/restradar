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
    var naturalCurrentInstruction: String? {
        guard let blocks = self.blocksLeft, let distanceLeft = self.distanceLeft else { return self.instructions }
        let naturalStart = "\(blocks > 0 ? ("In \(blocks) block\(distanceLeft.blocksPostFix), ") : (distanceLeft.steps > 10 ? "In \(distanceLeft.steps) step\(distanceLeft.stepsPostFix), " : ""))"
        
        return "\(naturalStart)\(self.instructions)"
    }
    
    var naturalInstructions: String? {
        guard let blocks = self.blocks else { return self.instructions }
        let naturalStart = "\(blocks > 0 ? ("\(blocks) block\(blocks == 1 ? "" : "s") later, ") : (self.distance.steps > 10 ? "\(self.distance.steps) step\(self.distance.steps == 1 ? "" : "s") later, " : ""))"
        
        return "\(naturalStart)\(self.instructions)"
    }
}

class Bathroom: Identifiable, Equatable, ObservableObject {
    var address: String
    var code: String?
    var comment: String?
    var hours: Hours?
    var id: Int
    var name: String
    
    @Published var coordinate: CLLocationCoordinate2D
    @Published var directions: [MKRoute.Step] = []
    @Published var distanceAway: String?
    @Published var timeAway: String?
    @Published var stepsAway: String?
    @Published var distanceMeters: CLLocationDistance?
    @Published var generalHeading: Double = 0.0
    @Published var heading: Double = 0.0
    @Published var route: MKRoute?
    
    var isFavorited: Bool {
        return BathroomAttendant.shared.favoriteBathrooms.contains(where: { $0.id == self.id })
    }

    var annotation: Annotation? {
        return Annotation(title: name, coordinate: coordinate)
    }
    
    var totalBlocks: String {
        var total = 0
        for step in directions {
            if let blocks = step.blocks {
                total += blocks
            }
        }
        return "\(total > 0 ? ("\(total) block\(total == 1 ? "" : "s")") : "")"
    }
    
    var currentRouteStep: MKRoute.Step? {
        guard let current = LocationAttendant.shared.current, let route = self.route else { return nil }
        
        let currentRect = MKCircle(center: current.coordinate, radius: 6.0).boundingMapRect
        
        for step in route.steps {
            let line = step.polyline
            
            if line.intersects(currentRect) {
                return(step)
            }
        }
        
        return nil
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, comment: String? = nil, code: String? = nil, hours: Hours? = nil, id: Int, distanceMeters: CLLocationDistance? = nil) {
        self.name = name
        self.address = address
        self.comment = comment
        self.code = code
        self.hours = hours
        self.id = id
        self.distanceMeters = distanceMeters
        self.coordinate = coordinate
        
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func ==(lhs: Bathroom, rhs: Bathroom) -> Bool {
        return (lhs.id == rhs.id && lhs.address == rhs.address && lhs.distanceMeters == rhs.distanceMeters && lhs.directions == rhs.directions && lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude && lhs.distanceAway == rhs.distanceAway && lhs.hours == rhs.hours && lhs.comment == rhs.comment)
    }
}

struct Hours: Codable, Hashable {
    var open: Date
    var close: Date
}
