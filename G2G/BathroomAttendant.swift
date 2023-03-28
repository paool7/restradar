//
//  BathroomAttendant.swift
//  G2G
//
//  Created by Paul Dippold on 3/18/23.
//

import Foundation
import CoreLocation

class BathroomAttendant: ObservableObject {
    static let shared = BathroomAttendant()
    
    @Published var defaults: [Bathroom] {
        didSet {
            self.objectWillChange.send()
        }
    }

    init(){
        self.defaults = [
            Bathroom(name: "HasenStüble", address: "1184 Nostrand Ave., Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6585688, longitude: -73.9506879), id: 1),
            Bathroom(name: "Le Point Value Thrift", address: "321 Clarkson Ave, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.6555898, longitude: -73.948961), id: 2),
            Bathroom(name: "Winthrop Playground", address: "164 Winthrop St, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.656620, longitude: -73.954193), comment: "Open during park hours", id: 3),
            Bathroom(name: "Brooklyn PERK Coffee", address: "605 Flatbush Ave, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.658599, longitude: -73.9603273), comment: "Free unlocked gender neutral/single stall bathroom all the way in the back", id: 4),
            Bathroom(name: "Nostrand Playground", address: "3002 Foster Ave, Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.638375, longitude: -73.9474496), id: 5),
            Bathroom(name: "LeFrak Center at Lakeside", address: "171 East Dr, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6639138, longitude: -73.9656772), comment: "In Prospect Park", id: 6),
            Bathroom(name: "Public Bathroom", address: "70 Parade Pl, Brooklyn, NY 1121", coordinate: CLLocationCoordinate2D(latitude: 40.6513557, longitude: -73.9652167), comment: "In Detective Dillon Stewart Playground", id: 7),
            Bathroom(name: "Public Bathroom", address: "116 East Dr, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6639138, longitude: -73.9656772), comment: "In Prospect Park\nBring your owns tissues if you can because it often runs out. Sometimes closed when it’s supposed to be open.", id: 8),
            Bathroom(name: "Brooklyn Public Library- Cortelyou Branch", address: "1305 Cortelyou Rd. at, Argyle Rd, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.6406079, longitude: -73.9660055), id: 9),
            Bathroom(name: "Wellhouse", address: "200 Well House Dr, Brooklyn, NY 11218", coordinate: CLLocationCoordinate2D(latitude: 40.656594952552695, longitude: -73.97055906109286), comment: "In Prospect Park", id: 10),
            Bathroom(name: "McDonald’s", address: "2154 Nostrand Ave., Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.6323542, longitude: -73.9479889), id: 11),
            Bathroom(name: "Agi’s Counter", address: "818 Franklin Ave, Brooklyn, NY 11225", coordinate: CLLocationCoordinate2D(latitude: 40.6699908, longitude: -73.958366), comment: "Recommended on Reddit", id: 12),
            Bathroom(name: "Chipotle Mexican Grill", address: "2166 Nostrand Ave., Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.6320053, longitude: -73.9479154), code: "2766", id: 13),
            Bathroom(name: "Elk Cafe", address: "154 Prospect Park Southwest, Brooklyn, NY 11218", coordinate: CLLocationCoordinate2D(latitude: 40.6549213, longitude: -73.9736356), id: 14),
            Bathroom(name: "Target", address: "1598 Flatbush Ave, Brooklyn, NY 11210", coordinate: CLLocationCoordinate2D(latitude: 40.6313473, longitude: -73.9463696), comment: "Next to the Starbucks inside the store", id: 15),
            Bathroom(name: "Starbucks", address: "341 Eastern Pkwy, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6710295, longitude: -73.957498), code: "123456", id: 16),
            Bathroom(name: "Bagel Pub", address: "775 Franklin Ave, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6722378, longitude: -73.9571095), comment: "Unlocked bathroom", id: 17),
            Bathroom(name: "Crown Heights Cafe", address: "764 Franklin Ave, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.672289, longitude: -73.9576119), id: 18),
            Bathroom(name: "Target", address: " 5200 Kings Hwy Ste A, Brooklyn, NY 11234", coordinate: CLLocationCoordinate2D(latitude: 40.6363315, longitude: -73.9274812), id: 19),
            Bathroom(name: "Windsor Terrace Library", address: "160 E 5th St, Brooklyn, NY 11218", coordinate: CLLocationCoordinate2D(latitude: 40.6486979, longitude: -73.9767751), id: 20),
            Bathroom(name: "Villager", address: "841 Classon Ave, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6719563, longitude: -73.960919), comment: "Unlocked bathroom in the back", id: 21),
            Bathroom(name: "Parade Ground Public Restroom", address: "305 Parkside Ave, Brooklyn, NY 11226", coordinate: CLLocationCoordinate2D(latitude: 40.6558738, longitude: -73.9589949), id: 22),
            Bathroom(name: "Brooklyn Museum", address: "200 Eastern Parkway, Brooklyn, NY 11238", coordinate: CLLocationCoordinate2D(latitude: 40.6713414, longitude: -73.9636813), id: 23),
            Bathroom(name: "Picnic House", address: "40 West Dr, Brooklyn, NY 11215", coordinate: CLLocationCoordinate2D(latitude: 40.6696918, longitude: -73.9718209), comment: "In Prospect Park", id: 24),
            Bathroom(name: "St Johns Park", address: "Troy Ave, Brooklyn, NY 11213", coordinate: CLLocationCoordinate2D(latitude: 40.6777027, longitude: -73.9358504), comment: "Usually open from early morning to late at night", id: 25)
            ]
    }
    
    func changeDefaults(_ defaults: [Bathroom]) {
        self.defaults = defaults
        self.objectWillChange.send()
    }
    
    func changeDefault(_ id: Int, to: Bathroom) {
        if let index = defaults.firstIndex(where: {$0.id == id}) {
            self.defaults[index] = to
            self.objectWillChange.send()
        }
    }
}
