//
//  BathroomList.swift
//  RestRadar
//
//  Created by Paul Dippold on 5/4/23.
//

import Foundation
import CoreLocation

struct LibraryListItemModel: Decodable {
    let name: String
    let comment: String
    let accessibility: String
}

struct BathroomListItemModel: Decodable {
    let lat: CLLocationDegrees
    let lng: CLLocationDegrees
    let name: String
    let comment: String
    let accessibility: String?
}

struct Constants { static func getBathrooms() -> [Bathroom] {
    let decoder = JSONDecoder()
    
    guard let jsonData = Constants.bathroomList.data(using: .utf8) else {
        print("Error: Cannot convert string to Data")
        return []
    }
    
    do {
        let listItems = try decoder.decode([BathroomListItemModel].self, from: jsonData)
        
        let bathrooms: [Bathroom] = listItems.compactMap { item in
            let coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng)
            
            let id = self.randomizeAndHyphenateWords(in: item.name) + UUID().uuidString
            
            return Bathroom(name: item.name, accessibility: Accessibility(rawValue: item.accessibility ?? "unknown") ?? .unknown, coordinate: coordinate, comment: item.comment, id: id)
        }
        return Array(Set(bathrooms))
    } catch {
        print(error)
    }
    
    
    return []
}
    
//    static func getLibraries(){
//        let decoder = JSONDecoder()
//        
//        guard let jsonData = Constants.libraryList.data(using: .utf8) else {
//            print("Error: Cannot convert string to Data")
//            return
//        }
//        
//        do {
//            let listItems = try decoder.decode([LibraryListItemModel].self, from: jsonData)
//            
//            let group = DispatchGroup()
//            var bathrooms: [Bathroom] = []
//            
//            for bathroom in listItems {
//                group.enter()
//
//                DispatchQueue.main.async(group: group) {
//                    LocationAttendant.shared.getLocation(from: bathroom.comment, completion: { location in
//                        if let location {
//                            let id = self.randomizeAndHyphenateWords(in: bathroom.name) + UUID().uuidString
//                            
//                            bathrooms.append(Bathroom(name: bathroom.name, accessibility: Accessibility(rawValue:  bathroom.accessibility) ?? .unknown, coordinate: location.coordinate, comment: bathroom.comment, id: id))
//                            
//                        } else {
//                            print("Couldn't find: \(bathroom.name)")
//                        }
//                        group.leave()
//                    })
//                }
//            }
//            
//            group.notify(queue: .main) {
//                let sorted = bathrooms.sorted(by: { $0.name < $1.name })
//                for bathroom in sorted {
//                    print(bathroom.description)
//                }
//            }
//            
//        } catch {
//            print(error)
//        }
//    }
    
    static func randomizeAndHyphenateWords(in input: String) -> String {
        var words = input.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        words.shuffle()
        
        let hyphenated = words.joined(separator: "-")
        return hyphenated
    }
    
    static let bathroomList = """
    [
    { "lat": 40.7957, "lng": -73.9685, "name": "Happy Warrior Playground Public Restroom", "comment": "West 98 Street & Amsterdam Avenue"
    },
    { "lat": 40.8705, "lng": -73.7866, "name": "Orchard Beach Nature Center", "comment": "at Orchard Beach, near Twin Island Trail"
    },
    { "lat": 40.7659, "lng": -73.7945, "name": "Auburndale Playground Public Restroom", "comment": "170-171 Streets, 33-35 Avenues"
    },
    { "lat": 40.8672, "lng": -73.7938, "name": "Orchard Beach Pavilion North Men's Public Restroom", "comment": "End of Orchard Beach Road, north side"
    },
    { "lat": 40.5979, "lng": -74.0, "name": "Bensonhurst Park Field House", "comment": "Cropsey Ave between Bay 28th St & Bay 29th St"
    },
    { "lat": 40.6934, "lng": -73.7781, "name": "174 St Playground Public Restroom", "comment": "174 Street & 113 Avenue"
    },
    { "lat": 40.7409, "lng": -73.8495, "name": "Playground For All Children Public Restroom", "comment": "111 Street and Corona Avenue"
    },
    { "lat": 40.8485, "lng": -73.8253, "name": "Playground For All Children Public Restroom", "comment": "Bruckner Expressway & Buhre Avenue"
    },
    { "lat": 40.6398, "lng": -74.0236, "name": "John Allen Payne Playground Public Restroom", "comment": "3 Ave. bet. 64 St. and 65 St."
    },
    { "lat": 40.8488, "lng": -73.852, "name": "Loreto Playground Public Restroom", "comment": "Morris Park Avenue, Haight Avenue, Tomlinson Avenue, Van Nest Avenue"
    },
    { "lat": 40.8318, "lng": -73.9252, "name": "Rev. T. Wendell Foster Recreation Center", "comment": "1020 Jerome Ave"
    },
    { "lat": 40.7219, "lng": -73.9606, "name": "Bushwick Inlet Park House", "comment": "Kent Ave. between N. 9 St. and N. 12 St."
    },
    { "lat": 40.7249, "lng": -73.8954, "name": "Frontera Park Public Restroom", "comment": "Between 55th Dr. & 58th Ave. and Between Brown Pl. & 69th St."
    },
    { "lat": 40.6359, "lng": -73.9122, "name": "Bildersee Playground Public Restroom", "comment": "Flatlands Avenue between East 81 & East 82 Streets"
    },
    { "lat": 40.6647, "lng": -73.8504, "name": "Harold Schneiderman Playground Public Restroom", "comment": "155 Avenue & 83 Street"
    },
    { "lat": 40.8193, "lng": -73.8497, "name": "Randall Playground Public Restroom", "comment": "Randall Avenue, Castle Hill Avenue"
    },
    { "lat": 40.7499, "lng": -74.0008, "name": "Chelsea Park Public Restroom", "comment": "West 27 Street & 9 Avenue"
    },
    { "lat": 40.6505, "lng": -73.9766, "name": "Greenwood Playground Public Restroom", "comment": "Fort Hamilton Parkway, Greenwood, East 5 Street"
    },
    { "lat": 40.7299, "lng": -73.8162, "name": "Vleigh Playground Public Restroom", "comment": "70 Road to 71 Avenue"
    },
    { "lat": 40.8907, "lng": -73.8974, "name": "Van Cortlandt Pool Public Restroom", "comment": "Broadway between West 242nd St. and Manhattan College Pkwy."
    },
    { "lat": 40.7013, "lng": -73.8545, "name": "Victory Field Public Restroom", "comment": "Woodhaven Blvd., Myrtle Ave., Park Dr."
    },
    { "lat": 40.8753, "lng": -73.8927, "name": "Harris Playground Public Restroom", "comment": "Bedford Park Boulevard W between Goulden Avenue & Paul Avenue"
    },
    { "lat": 40.5766, "lng": -74.0995, "name": "Midland Field Public Restroom", "comment": "Midland Avenue & Mason Avenue"
    },
    { "lat": 40.6468, "lng": -73.8995, "name": "100% Playground Public Restroom", "comment": "Glenwood Road, East 100 & East 101 Streets"
    },
    { "lat": 40.8684, "lng": -73.868, "name": "Parkside Playground Public Restroom", "comment": "Arnow Avenue, Adee Avenue, Olinville Avenue"
    },
    { "lat": 40.6187, "lng": -73.972, "name": "Friends Field Public Restroom", "comment": "Avenue L, East 4 Street, McDonald Avenue, Avenue M"
    },
    { "lat": 40.7003, "lng": -73.9285, "name": "Fermi Playground Public Restroom", "comment": "Troutman Street & Central Avenue"
    },
    { "lat": 40.7511, "lng": -73.8274, "name": "Kissena Corridor Park-Queens Botanical Garden-Roof Canopy/Auditorium", "comment": "Dahlia Avenue"
    },
    { "lat": 40.8043, "lng": -73.917, "name": "Millbrook Playground Public Restroom", "comment": "East 135 Street, Cypress Avenue"
    },
    { "lat": 40.682, "lng": -73.9442, "name": "Potomac Playground Public Restroom", "comment": "Tompkins Avenue & Halsey Street"
    },
    { "lat": 40.7416, "lng": -73.7485, "name": "Alley Pond Spring Public Restroom", "comment": "Springfield Boulevard, 73rd Avenue, 76th Avenue to tree line & natural area"
    },
    { "lat": 40.8698, "lng": -73.8527, "name": "Eastchester Playground Public Restroom", "comment": "Adee Avenue & Tenbroeck Avenue"
    },
    { "lat": 40.6355, "lng": -74.0193, "name": "Millennium Playground Public Restroom", "comment": "5th Ave. between 66th St. & 67th St."
    },
    { "lat": 40.7128, "lng": -73.9761, "name": "Fire Boat House Public Restroom", "comment": "East River Park at Grand Street"
    },
    { "lat": 40.8099, "lng": -73.9105, "name": "St Mary's Playground East Public Restroom", "comment": "Jackson Avenue between East 144 and 145 Streets"
    },
    { "lat": 40.771, "lng": -73.779, "name": "Raymond O'Connor Park Public Restroom", "comment": "Corp. Kennedy Street & 33 Avenue"
    },
    { "lat": 40.704, "lng": -73.7851, "name": "173rd St Playground Public Restroom", "comment": "173rd St. & 106th Ave."
    },
    { "lat": 40.7872, "lng": -73.9472, "name": "Cherry Tree Park Public Restroom", "comment": "99 to 100 Streets, 3 Avenue"
    },
    { "lat": 40.6945, "lng": -73.9467, "name": "Willoughby Playground Public Restroom", "comment": "Tompkins & Willoughby Avenues"
    },
    { "lat": 40.6766, "lng": -73.9655, "name": "Underhill Playground Public Restroom", "comment": "Underhill Avenue & Prospect Place"
    },
    { "lat": 40.7447, "lng": -73.7875, "name": "Underhill Playground Public Restroom", "comment": "Peck Avenue & 188 Street"
    },
    { "lat": 40.6589, "lng": -73.8794, "name": "Jerome Playground Public Restroom", "comment": "Wortman Ave between Jerome St & Warwick St"
    },
    { "lat": 40.796, "lng": -73.9235, "name": "Randall's Island Golf Center Public Restroom", "comment": "Central Road & Bronx Shore Road"
    },
    { "lat": 40.7614, "lng": -73.9413, "name": "Spirit Playground Public Restroom", "comment": "36 Avenue between 9 & 10 Streets"
    },
    { "lat": 40.6807, "lng": -73.9227, "name": "Brevoort Playground Public Restroom", "comment": "Ralph Ave. bet. Chauncey St. and Sumpter St."
    },
    { "lat": 40.6778, "lng": -73.7841, "name": "Baisley Pond Park House Public Restroom", "comment": "Lakeview Blvd E. & 122nd Ave"
    },
    { "lat": 40.6954, "lng": -73.9666, "name": "Washington Hall Park Public Restroom", "comment": "Park, Washington Avenues to Hall Street"
    },
    { "lat": 40.8381, "lng": -73.8934, "name": "Crotona Park Nature Center", "comment": "Crotona Park East & Charlotte Street"
    },
    { "lat": 40.8065, "lng": -73.9356, "name": "Alice Kornegay Triangle Public Restroom", "comment": "Lexington Avenue, East 128 & East 129 Streets"
    },
    { "lat": 40.7175, "lng": -74.0115, "name": "Washington Market Park Public Restroom", "comment": "Greenwich St. & Chambers St."
    },
    { "lat": 40.7033, "lng": -73.8034, "name": "Rufus King Park Public Restroom", "comment": "Jamaica Avenue, 153 Street, 89 Avenue, 150 Street"
    },
    { "lat": 40.6971, "lng": -73.9486, "name": "Stockton Playground Public Restroom", "comment": "Marcy & Park Avenues"
    },
    { "lat": 40.8514, "lng": -73.8686, "name": "Brady Playground Public Restroom", "comment": "Bronx Park East between Bronxdale Avenue and Unionport Road"
    },
    { "lat": 40.785, "lng": -73.8328, "name": "136 St Playground Public Restroom", "comment": "132 to 138 Streets, 14 Road"
    },
    { "lat": 40.8625, "lng": -73.8582, "name": "Mazzei Playground Public Restroom", "comment": "Mace Avenue, Williamsbridge Road"
    },
    { "lat": 40.7655, "lng": -73.8714, "name": "East Elmhurst Playground Public Restroom", "comment": "25 Avenue & 98 Street"
    },
    { "lat": 40.7363, "lng": -73.9896, "name": "Evelyn's Playground Public Restroom", "comment": "Union Square West Between E. 16th & E. 17th St."
    },
    { "lat": 40.8837, "lng": -73.8816, "name": "Sachkerah Woods Playground Public Restroom", "comment": "East 212 Street and Jerome Avenue"
    },
    { "lat": 40.5161, "lng": -74.1894, "name": "Wolfe's Pond Modular Public Restroom - Men's", "comment": "Prefab CS near beach, East structure"
    },
    { "lat": 40.726, "lng": -73.7289, "name": "Breininger Park Public Restroom", "comment": "Braddock Avenue & 240 Street"
    },
    { "lat": 40.7524, "lng": -73.965, "name": "MacArthur Playground Public Restroom", "comment": "East 49 Street & East River Drive"
    },
    { "lat": 40.6593, "lng": -73.9446, "name": "Wingate Park Public Restroom", "comment": "Brooklyn Avenue & Rutland Road"
    },
    { "lat": 40.6922, "lng": -73.9747, "name": "Visitors Center at Fort Greene Park", "comment": "Visitors Center at Fort Greene Park"
    },
    { "lat": 40.629, "lng": -73.896, "name": "Canarsie Park Public Restroom", "comment": "Seaview Ave. & East 88th St."
    },
    { "lat": 40.8059, "lng": -73.8886, "name": "Barretto Point Park Public Restroom", "comment": "Tiffany Street & Viele Avenue"
    },
    { "lat": 40.5956, "lng": -73.7446, "name": "Beach 9 Playground Public Restroom", "comment": "Beach 9th Street, North of the Boardwalk"
    },
    { "lat": 40.8046, "lng": -73.9448, "name": "Marcus Garvey Park Public Restroom", "comment": "18 Mount Morris Park West"
    },
    { "lat": 40.7267, "lng": -73.7754, "name": "Redwood Playground Public Restroom", "comment": "193 Street and Aberdeen Road"
    },
    { "lat": 40.7435, "lng": -73.8148, "name": "Captain Mario Fajardo Park Public Restroom", "comment": "Kissena Boulevard & Booth Memorial Avenue"
    },
    { "lat": 40.7023, "lng": -73.8681, "name": "Dry Harbor Playground Public Restroom", "comment": "80 Street & Myrtle Avenue"
    },
    { "lat": 40.6776, "lng": -73.8842, "name": "Sperandeo Brothers Playground Public Restroom", "comment": "Atlantic Avenue & Elton Street"
    },
    { "lat": 40.7044, "lng": -74.0159, "name": "The Battery Public Restroom", "comment": "Battery Pl. & Washington St."
    },
    { "lat": 40.8911, "lng": -73.8939, "name": "Van Cortlandt Nature Center", "comment": "246th Street and Broadway"
    },
    { "lat": 40.7109, "lng": -73.9109, "name": "Grover Cleveland Playground Public Restroom", "comment": "Rene Court, Grandview Avenue, Stanjope Street & Fairview Avenue"
    },
    { "lat": 40.5846, "lng": -73.8108, "name": "Rockaway Playground M Public Restroom", "comment": "Boardwalk between Beach 84th St and Beach 90th St"
    },
    { "lat": 40.6746, "lng": -73.912, "name": "Ocean Hill Playground Public Restroom", "comment": "Bergen Street, Rockaway Avenue, Dean Street"
    },
    { "lat": 40.7635, "lng": -73.8247, "name": "Margaret I. Carman Green - Weeping Beech Public Restroom", "comment": "37 Avenue & Bowne Street"
    },
    { "lat": 40.8811, "lng": -73.9008, "name": "Bailey Playground Public Restroom", "comment": "W. 234th St. between Bailey Ave. & Major Deegan Expwy."
    },
    { "lat": 40.5971, "lng": -73.9574, "name": "Mellett Playground Public Restroom", "comment": "Avenue V between East 13 & East 14 Streets"
    },
    { "lat": 40.8129, "lng": -73.9134, "name": "St Mary's Playground West Public Restroom", "comment": "St. Ann's Avenue & East 147 Street"
    },
    { "lat": 40.6856, "lng": -73.9464, "name": "Hattie Carthan Playground Public Restroom", "comment": "East of Marcy Street"
    },
    { "lat": 40.6583, "lng": -73.8875, "name": "Linden Park Public Restroom", "comment": "Stanley Avenue, Linden Boulevard"
    },
    { "lat": 40.5161, "lng": -74.1895, "name": "Wolfe's Pond Modular Public Restroom - Women's", "comment": "Prefab CS near beach, West structure"
    },
    { "lat": 40.6938, "lng": -73.9716, "name": "Oracle Playground Public Restroom", "comment": "Adelphi & Myrtle Avenues"
    },
    { "lat": 40.7691, "lng": -73.9491, "name": "John Jay Park Pool Building", "comment": "East of York Avenue on 77th St."
    },
    { "lat": 40.776, "lng": -73.8172, "name": "Leonardo Ingravallo Playground Public Restroom", "comment": "Bayside Avenue, 25 Avenue, 149 to 150 Streets"
    },
    { "lat": 40.5586, "lng": -74.1025, "name": "Great Kills Park-New Dorp Beach Modular Public Restroom - Women's", "comment": "Prefab CS near beach, South structure"
    },
    { "lat": 40.8188, "lng": -73.8983, "name": "Rainey Park Public Restroom", "comment": "Dawson Street between Polite Ave & Rogers Pl."
    },
    { "lat": 40.5372, "lng": -74.1624, "name": "Lieutenant John H. Martinson Playground Public Restroom", "comment": "Osborne Street and Preston Avenue"
    },
    { "lat": 40.8226, "lng": -73.8883, "name": "Lyons Square Playground Public Restroom", "comment": "Aldus St. between Bryant Ave. & Longfellow Ave."
    },
    { "lat": 40.5918, "lng": -73.9456, "name": "Bill Brown Playground Public Restroom", "comment": "Bedford Avenue, Avenue X to Avenue Y, E 24 Street"
    },
    { "lat": 40.7492, "lng": -73.8038, "name": "Kissena Park- Boathouse Public Restroom", "comment": "Oak Avenue & 164th Street"
    },
    { "lat": 40.7019, "lng": -73.7835, "name": "Detective Keith L Williams Park-Field House", "comment": "106-16 173rd Street between 106 Av and 107 Av"
    },
    { "lat": 40.8122, "lng": -73.9464, "name": "Langston Hughes Playground Public Restroom", "comment": "Adam Clayton Powell Jr. Blvd & W. 130th St"
    },
    { "lat": 40.8272, "lng": -73.9146, "name": "Arcilla Playground Public Restroom", "comment": "Teller Avenue, Park Avenue, Clay Avenue, East 64 Street"
    },
    { "lat": 40.7653, "lng": -73.9586, "name": "St. Catherine's Park Public Restroom", "comment": "1st Avenue between E. 67th St & E. 68th St."
    },
    { "lat": 40.6795, "lng": -73.8762, "name": "City Line Park Public Restroom", "comment": "Atlantic & Fountain Avenues"
    },
    { "lat": 40.5749, "lng": -73.9598, "name": "Coney Island Beach & Boardwalk-Building", "comment": "Coney Island Boardwalk East Between Brighton 1 Rd. and Brighton 2 St."
    },
    { "lat": 40.6629, "lng": -73.9635, "name": "Children's Corner Public Restroom", "comment": "Willink Hill, Ocean Ave. & Flatbush Ave."
    },
    { "lat": 40.6479, "lng": -73.9314, "name": "Tilden Playground Public Restroom", "comment": "Tilden Avenue, East 48 to East 49 Streets"
    },
    { "lat": 40.8841, "lng": -73.8452, "name": "Edenwald Playground Public Restroom", "comment": "East 226 Drive, Schieffelin Avenue"
    },
    { "lat": 40.6814, "lng": -73.8568, "name": "Ampere Playground Public Restroom", "comment": "101 Avenue & 82 Street"
    },
    { "lat": 40.8657, "lng": -73.8505, "name": "Allerton Playground Public Restroom", "comment": "Allerton Avenue between Throop Avenue & Stedman Place"
    },
    { "lat": 40.8651, "lng": -73.9295, "name": "Anne Loftus Playground Public Restroom", "comment": "Broadway & Dyckman Street"
    },
    { "lat": 40.7419, "lng": -73.848, "name": "FMCP-Carousel Loop Public Restroom", "comment": "23 Carousel Loop"
    },
    { "lat": 40.781, "lng": -73.9616, "name": "Ancient Playground Public Restroom", "comment": "85th St. & 5th Ave."
    },
    { "lat": 40.7362, "lng": -73.8698, "name": "Newtown Playground Public Restroom", "comment": "92nd St. & 56th Ave."
    },
    { "lat": 40.6947, "lng": -73.8215, "name": "Phil 'Scooter' Rizzuto Park Public Restroom", "comment": "125 Street & Atlantic Avenue"
    },
    { "lat": 40.7971, "lng": -73.9515, "name": "Charles A. Dana Discovery Center", "comment": "Inside the Park at 110th Street between Fifth and Lenox Avenues"
    },
    { "lat": 40.7159, "lng": -73.9816, "name": "Luther Gulick Park Public Restroom", "comment": "Broome Street between Bialystoker Pl. & Columbia St."
    },
    { "lat": 40.8496, "lng": -73.9021, "name": "Richman (Echo) Park Upper Level Public Restroom", "comment": "East 178 Street & Ryer Avenue, Upper Level"
    },
    { "lat": 40.8674, "lng": -73.7937, "name": "Orchard Beach Pavilion North Women's Public Restroom", "comment": "End of Orchard Beach Road, north side"
    },
    { "lat": 40.722, "lng": -73.9518, "name": "McCarren Park Public Restroom", "comment": "903 Lorimer St"
    },
    { "lat": 40.5616, "lng": -74.1115, "name": "Dugan Playground Public Restroom", "comment": "Mill Road & Tysens Lane"
    },
    { "lat": 40.5779, "lng": -73.8352, "name": "Beach 115th Street Public Restroom", "comment": "Beach 115th St. & Rockaway Boardwalk"
    },
    { "lat": 40.7239, "lng": -73.9728, "name": "East River Playground Public Restroom", "comment": "Northern end of park at East 10th Street."
    },
    { "lat": 40.7892, "lng": -73.9379, "name": "East River Playground Public Restroom", "comment": "FDR Drive, East 106 to East 107 Streets"
    },
    { "lat": 40.7062, "lng": -74.004, "name": "Imagination Playground Public Restroom", "comment": "Front St., John St., and South St."
    },
    { "lat": 40.6788, "lng": -73.942, "name": "St. Andrew's Playground Public Restroom", "comment": "Atlantic Avenue & Herkimer Street"
    },
    { "lat": 40.742, "lng": -73.9608, "name": "Hunter's Point South Park Pavilion", "comment": "Center Blvd. & Borden Ave."
    },
    { "lat": 40.8005, "lng": -73.9733, "name": "Structure north of W 102nd St soccer field stairs", "comment": "North of W 102nd St soccer field stairs"
    },
    { "lat": 40.8767, "lng": -73.8786, "name": "Williamsbridge Oval Recreation Center", "comment": "Reservoir Oval East & Van Cortlandt Avenue East"
    },
    { "lat": 40.6283, "lng": -74.099, "name": "Silver Lake Park Field House", "comment": "Victory Boulevard, Clove Road, Forest Avenue"
    },
    { "lat": 40.5798, "lng": -74.0759, "name": "South Beach Public Restroom", "comment": "Boardwalk, near Seaview Ave."
    },
    { "lat": 40.6203, "lng": -73.958, "name": "Kolbert Playground Public Restroom", "comment": "Avenue L, East 17 to East 18 Streets"
    },
    { "lat": 40.8747, "lng": -73.8654, "name": "Gun Hill Playground Public Restroom", "comment": "Holland Avenue, Magenta Street, Cueger Avenue"
    },
    { "lat": 40.873, "lng": -73.8711, "name": "Rosewood Playground Public Restroom", "comment": "Bronx River Parkway & Rosewood Street"
    },
    { "lat": 40.8242, "lng": -73.8978, "name": "Horseshoe Playground Public Restroom", "comment": "Hall Place, Rogers Place, East 165 Street"
    },
    { "lat": 40.8111, "lng": -73.9472, "name": "St. Nicholas Playground South Public Restroom", "comment": "West 129 & 7 Avenue"
    },
    { "lat": 40.6851, "lng": -73.919, "name": "Saratoga Park Public Restroom", "comment": "Howard Avenue, Halsey, Macon Streets"
    },
    { "lat": 40.8417, "lng": -73.9379, "name": "Audubon Playground Public Restroom", "comment": "West 170 Street & Audubon Avenue"
    },
    { "lat": 40.6917, "lng": -73.9578, "name": "Star Spangled Playground Public Restroom", "comment": "Franklin & Willoughby Avenues"
    },
    { "lat": 40.7485, "lng": -73.9885, "name": "Greeley Square Park Public Restroom", "comment": "Ave. of the Americas & W. 32nd St."
    },
    { "lat": 40.7754, "lng": -73.9688, "name": "Loeb Boathouse", "comment": "East Side between 74th and 75th Streets"
    },
    { "lat": 40.7904, "lng": -73.9546, "name": "Robert Bendheim Playground Public Restroom", "comment": "100th Street and Fifth Ave"
    },
    { "lat": 40.7955, "lng": -73.9189, "name": "Sunken Meadow Public Restroom", "comment": "Sunken Meadow Loop, Between Fields 13 and 19"
    },
    { "lat": 40.5734, "lng": -73.9759, "name": "West 8th Street Public Restroom", "comment": "Boardwalk, near West. 8th Street Entrance"
    },
    { "lat": 40.6879, "lng": -73.9255, "name": "P.O. Reinaldo Salgado Playground Public Restroom", "comment": "Madison Street & Patchen Avenue"
    },
    { "lat": 40.8351, "lng": -73.8962, "name": "Martin Van Buren Playground Public Restroom", "comment": "Crotona East & Claremont Parkway"
    },
    { "lat": 40.657, "lng": -73.8695, "name": "Berriman Playground Public Restroom", "comment": "Berriman St between Vandalia Ave & Schroeders Ave"
    },
    { "lat": 40.7046, "lng": -73.9044, "name": "Rosemary's Playground Public Restroom", "comment": "Woodward Avenue, Woodbine Street, Fairview Avenue"
    },
    { "lat": 40.7423, "lng": -73.8824, "name": "Moore Homestead Playground Public Restroom", "comment": "Broadway & 83 Street"
    },
    { "lat": 40.646, "lng": -73.9805, "name": "Albemarle Playground Public Restroom", "comment": "Albermarle Road & Dahill Road"
    },
    { "lat": 40.823, "lng": -73.8631, "name": "Story Playground Public Restroom", "comment": "Story Avenue, Thieriot Avenue, Taylor Avenue"
    },
    { "lat": 40.6933, "lng": -73.7956, "name": "Marconi Park Public Restroom", "comment": "109 Avenue & 155 Street"
    },
    { "lat": 40.6264, "lng": -74.0363, "name": "Russell Pedersen Playground Public Restroom", "comment": "Colonial Road, 83 to 85 Streets"
    },
    { "lat": 40.5942, "lng": -73.7506, "name": "Beach 17 Playground Public Restroom", "comment": "Beach 17th St. & Seagirt Blvd."
    },
    { "lat": 40.8629, "lng": -73.8366, "name": "Burns Playground Public Restroom", "comment": "Mace Ave. between Lodovick Ave. & Gunther Ave."
    },
    { "lat": 40.7722, "lng": -73.9776, "name": "Tavern on the Green", "comment": "West Side between 66th and 67th Streets"
    },
    { "lat": 40.724, "lng": -73.8516, "name": "Russell Sage Playground Public Restroom", "comment": "68 Avenue, Booth to Austin Streets"
    },
    { "lat": 40.6805, "lng": -74.0019, "name": "Dimattina Playground Public Restroom", "comment": "Hicks & Rapelye Streets"
    },
    { "lat": 40.8137, "lng": -73.939, "name": "Howard Bennett Playground Public Restroom", "comment": "West 135 to West 136 Streets, Lenox to 5 Avenues"
    },
    { "lat": 40.6674, "lng": -73.8902, "name": "Martin Luther King Jr. Playground Public Restroom", "comment": "Dumont, Blake, Miller Avenues"
    },
    { "lat": 40.7725, "lng": -73.9857, "name": "Guggenheim Bandshell", "comment": "Amsterdam Ave. and W. 62 St."
    },
    { "lat": 40.6367, "lng": -73.9201, "name": "Glenwood Playground Public Restroom", "comment": "Ralph Avenue & Farragut Road"
    },
    { "lat": 40.6537, "lng": -73.894, "name": "Breukelen Playground Public Restroom", "comment": "Louisiana & Flatlands Avenue"
    },
    { "lat": 40.6146, "lng": -73.9448, "name": "PFC Norton Playground Public Restroom", "comment": "Nostrand Avenue & Marine Parkway"
    },
    { "lat": 40.5906, "lng": -73.9385, "name": "Playground 286 Public Restroom", "comment": "Avenue Y, between Brown & Haring Streets"
    },
    { "lat": 40.7144, "lng": -73.984, "name": "Sol Lain Playground Public Restroom", "comment": "Broadway, Henry Street, Samuel Dickstein Place"
    },
    { "lat": 40.6608, "lng": -73.9653, "name": "Prospect Park Audubon Center", "comment": "101 East Dr"
    },
    { "lat": 40.6182, "lng": -74.1072, "name": "District 1 Headquarters", "comment": "Park Drive, South of Parking Lot"
    },
    { "lat": 40.7414, "lng": -73.7764, "name": "Holy Cow Playground Public Restroom", "comment": "Peck Avenue Between 64th Ave. & 67th Ave."
    },
    { "lat": 40.6203, "lng": -73.9372, "name": "Sarsfield Playground Public Restroom", "comment": "East 38 Street & Ryder Street, Avenue M"
    },
    { "lat": 40.7898, "lng": -73.9687, "name": "Sol Bloom Playground Public Restroom", "comment": "Columbus Avenue, West 91 to West 92 Streets, Central Park West"
    },
    { "lat": 40.7973, "lng": -73.9591, "name": "The Great Hill Public Restroom", "comment": "West Side from 103rd to 107th Streets"
    },
    { "lat": 40.8026, "lng": -73.9719, "name": "Ellington in the Park", "comment": "Riverside Dr & W 105th St"
    },
    { "lat": 40.6089, "lng": -74.0, "name": "Garibaldi Playground Public Restroom", "comment": "82 to 83 Street at 18 Avenue"
    },
    { "lat": 40.6295, "lng": -74.1151, "name": "Austin J. McDonald Playground Public Restroom", "comment": "Forest Avenue, Myrtle Avenue between Broadway & Burgher"
    },
    { "lat": 40.5586, "lng": -74.1024, "name": "Great Kills Park-New Dorp Beach Modular Public Restroom - Men's", "comment": "Prefab CS near beach, North structure"
    },
    { "lat": 40.6961, "lng": -73.912, "name": "Bushwick Playground Public Restroom", "comment": "Knickerbocker Ave between Putnam Ave & Woodbine St"
    },
    { "lat": 40.7017, "lng": -73.9395, "name": "Bushwick Playground Public Restroom", "comment": "Flushing Avenue, Bushwick Avenue & Humboldt Street"
    },
    { "lat": 40.7235, "lng": -73.937, "name": "Sgt. William Dougherty Playground Public Restroom", "comment": "Anthony St. & Vandervoort Ave."
    },
    { "lat": 40.8113, "lng": -73.9657, "name": "Riverside Clay Tennis Courts Public Restroom", "comment": "96th Street at the river"
    },
    { "lat": 40.7268, "lng": -73.9814, "name": "Tompkins Square Park Public Restroom", "comment": "Avenues A to B, East 7 to East 10 Streets"
    },
    { "lat": 40.669, "lng": -73.9119, "name": "Chester Playground Public Restroom", "comment": "Chester Street, Sutter Avenue"
    },
    { "lat": 40.7117, "lng": -73.9798, "name": "Corlears Hook Park Public Restroom", "comment": "Cherry St. & Jackson St."
    },
    { "lat": 40.6011, "lng": -73.9722, "name": "McDonald Playground Public Restroom", "comment": "McDonald Avenue, between Avenues S & T"
    },
    { "lat": 40.611, "lng": -73.7491, "name": "Redfern Playground Public Restroom", "comment": "B 12 Street & Redfern Avenue"
    },
    { "lat": 40.7149, "lng": -74.0001, "name": "Columbus Park Playground Public Restroom", "comment": "Mid-Park between Baxter and Mulberry Streets"
    },
    { "lat": 40.73, "lng": -74.0029, "name": "Downing Street Playground Public Restroom", "comment": "Downing to Carmine Streets, Avenue of the Americas"
    },
    { "lat": 40.6833, "lng": -73.905, "name": "Rudd Playground Public Restroom", "comment": "Aberdeen Street & Bushwick Avenue"
    },
    { "lat": 40.7937, "lng": -73.9531, "name": "Conservatory Garden Men's Public Restroom", "comment": "5th Avenue, 103rd Street to 106th Street"
    },
    { "lat": 40.8229, "lng": -73.9075, "name": "Hilton White Playground Public Restroom", "comment": "Caldwell Avenue, East 163 Street, East 161 Street"
    },
    { "lat": 40.7759, "lng": -73.9252, "name": "Astoria Park Field House", "comment": "Near the track and tennis courts at Astoria Park South and 18th Street"
    },
    { "lat": 40.6857, "lng": -73.7701, "name": "Roy Wilkins Playground Public Restroom", "comment": "Enter at Baisley Blvd. & 177th St."
    },
    { "lat": 40.6609, "lng": -73.9069, "name": "Newport Playground Public Restroom", "comment": "Newport Avenue & Osborn Street"
    },
    { "lat": 40.7389, "lng": -74.0047, "name": "Corporal John A. Seravalli Playground Public Restroom", "comment": "Hudson & Horatio Streets"
    },
    { "lat": 40.7011, "lng": -73.843, "name": "Jackson Pond Playground Public Restroom", "comment": "108 Street and Park Lane South"
    },
    { "lat": 40.8637, "lng": -73.9049, "name": "Devoe Park Public Restroom", "comment": "West Fordham Road, University Avenue, Sedgwick Avenue, Father Zeiser Place"
    },
    { "lat": 40.5717, "lng": -73.9959, "name": "Nautilus Playground Public Restroom", "comment": "West 30 Street at Boardwalk"
    },
    { "lat": 40.6674, "lng": -73.9074, "name": "Dr. Green Playground Public Restroom", "comment": "Mother Gaston Boulevard (Stone Avenue) & Sutter Avenues"
    },
    { "lat": 40.7131, "lng": -73.7581, "name": "Haggerty Park Public Restroom", "comment": "202 Street & Jamaica Avenue"
    },
    { "lat": 40.6898, "lng": -73.9465, "name": "Herbert Von King Cultural Arts Center", "comment": "Greene, Marcy, Lafayette, Tompkins Avenues"
    },
    { "lat": 40.612, "lng": -74.0357, "name": "4th Avenue Entrance Public Restroom", "comment": "Shore Road between 3rd Ave. & 4th Ave."
    },
    { "lat": 40.7831, "lng": -73.9308, "name": "Wards Meadow Fields Public Restroom", "comment": "Wards Meadow Loop, near Field 71"
    },
    { "lat": 40.8908, "lng": -73.8641, "name": "227th Street Playground Public Restroom", "comment": "Bronx Boulevard between East 226 and East 228 Streets"
    },
    { "lat": 40.7109, "lng": -73.739, "name": "Wayanda Park Public Restroom", "comment": "Robard Lane & 217 Street"
    },
    { "lat": 40.8113, "lng": -73.9227, "name": "Willis Playground Public Restroom", "comment": "East 139 Street, East 140 Street, Willis & Alexander Avenues"
    },
    { "lat": 40.6971, "lng": -73.9428, "name": "Sumner Playground Public Restroom", "comment": "Throop, Park, Mytrle Avenues"
    },
    { "lat": 40.773, "lng": -73.9744, "name": "Sheep Meadow at Mineral Springs Pavilion", "comment": "Mid-park at 69th Street"
    },
    { "lat": 40.7569, "lng": -73.7281, "name": "Challenge Playground Public Restroom", "comment": "251 Street & 63 Avenue"
    },
    { "lat": 40.5724, "lng": -74.086, "name": "Midland Beach Lot 8 Modular Public Restroom - Men's", "comment": "Father Capodonno Blvd at Hunter Avenue"
    },
    { "lat": 40.5725, "lng": -74.0859, "name": "Midland Beach Lot 8 Modular Public Restroom - Women's", "comment": "FR Capodanno Blvd at Hunter Avenue"
    },
    { "lat": 40.6967, "lng": -73.986, "name": "McLaughlin Park Public Restroom", "comment": "Tillary Street, Jay Street, Cathedral Place, Bridge Street"
    },
    { "lat": 40.8137, "lng": -73.9509, "name": "St. Nicholas Playground at West 129th St. Public Restroom", "comment": "St. Nicholas Terrace and West 129th Street"
    },
    { "lat": 40.6886, "lng": -73.9667, "name": "Underwood Park Public Restroom", "comment": "Lafayette & Waverly Avenues"
    },
    { "lat": 40.8097, "lng": -73.9392, "name": "P.S. 133 / Moore Playground Public Restroom", "comment": "Madison Ave. between E. 130 St. and E. 131 St."
    },
    { "lat": 40.8674, "lng": -73.9291, "name": "Payson Nature Center", "comment": "Gaelic Field and Area around Salt Marsh West of Indian Road (at 218th Street)"
    },
    { "lat": 40.7081, "lng": -73.9641, "name": "Bedford Playground Public Restroom", "comment": "Bedford Avenue & South 9 Street, Division Avenue"
    },
    { "lat": 40.709, "lng": -73.9389, "name": "Ten Eyck Playground Public Restroom", "comment": "Meserole St. & Bushwick Pl."
    },
    { "lat": 40.7758, "lng": -73.8373, "name": "College Point Fields Public Restroom", "comment": "130th Street & 23rd Avenue"
    },
    { "lat": 40.5828, "lng": -74.0898, "name": "Dongan Playground Public Restroom", "comment": "Mason Ave. between Buel Ave. and Dongan Hills Ave."
    },
    { "lat": 40.7411, "lng": -73.9224, "name": "L/CPL Thomas P. Noonan Jr. Playground Public Restroom", "comment": "Greenpoint & 47 Avenues, 43 Street"
    },
    { "lat": 40.8679, "lng": -73.8424, "name": "Angelo Campanaro Playground Public Restroom", "comment": "Eastchester Rd., E. Gun Hill Rd., and Arrow Ave."
    },
    { "lat": 40.7402, "lng": -73.9027, "name": "Big Bush Playground Public Restroom", "comment": "61 Street, north and south of Brooklyn-Queens Expressway"
    },
    { "lat": 40.7097, "lng": -73.9559, "name": "Rodney Playground South Public Restroom", "comment": "Rodney St. Between S. 3rd St. & S. 4th St."
    },
    { "lat": 40.7386, "lng": -73.7566, "name": "Telephone Playground Public Restroom", "comment": "Bell Boulevard, 75 Avenue & 217 Street"
    },
    { "lat": 40.8269, "lng": -73.8978, "name": "Rev J Polite Playground Public Restroom", "comment": "Rev. James Polite Avenue, Intervale Avenue, East 167 Street"
    },
    { "lat": 40.8959, "lng": -73.879, "name": "Indian Field Public Restroom", "comment": "East 233rd Street and Van Cortlandt Park East"
    },
    { "lat": 40.6508, "lng": -73.9682, "name": "Parade Ground Public Restroom", "comment": "Between Parkside Ave. & Caton Ave, and Rugby Rd. & Argyle Rd."
    },
    { "lat": 40.7064, "lng": -73.7747, "name": "Peters Field Public Restroom", "comment": "183 Place & Henderson Avenue"
    },
    { "lat": 40.8199, "lng": -73.9085, "name": "Grove Hill Playground Public Restroom", "comment": "East 158 Street, Caldwell Avenue, Eagle Avenue"
    },
    { "lat": 40.8856, "lng": -73.8392, "name": "Stars & Stripes Playground Public Restroom", "comment": "Baychester Avenue, Crawford Avenue"
    },
    { "lat": 40.5521, "lng": -74.1361, "name": "Greencroft Playground Public Restroom", "comment": "Redgrave, Ainsworth & Durant Avenues"
    },
    { "lat": 40.7741, "lng": -73.7677, "name": "John Golden Park Public Restroom", "comment": "215 Place, south of 32 Avenue"
    },
    { "lat": 40.761, "lng": -73.9113, "name": "Astoria Heights Playground Public Restroom", "comment": "30 Road, 45 to 46 Streets"
    },
    { "lat": 40.5828, "lng": -74.1225, "name": "High Rock Visitors Center", "comment": "Paw Trail & Red Dot Trail"
    },
    { "lat": 40.8068, "lng": -73.9578, "name": "Morningside Playground Public Restroom", "comment": "West 117th Street & Morningside Avenue"
    },
    { "lat": 40.6338, "lng": -74.1291, "name": "Levy Playground Field House", "comment": "Jewett & Castleton Avenues"
    },
    { "lat": 40.6721, "lng": -73.9659, "name": "Mount Prospect Park Public Restroom", "comment": "Eastern Parkway, Underhill Avenue"
    },
    { "lat": 40.8271, "lng": -73.8737, "name": "Parque De Los Ninos Public Restroom", "comment": "Morrison Avenue & Watson Street"
    },
    { "lat": 40.6972, "lng": -73.8581, "name": "Forest Parkway Tennis House Public Restroom", "comment": "Park Lane South to north of tennis courts"
    },
    { "lat": 40.5761, "lng": -73.9788, "name": "Luna Playground Public Restroom", "comment": "W. 12th St. & Surf Ave."
    },
    { "lat": 40.6738, "lng": -73.9353, "name": "St. John's Park Public Restroom", "comment": "1251 Prospect Place"
    },
    { "lat": 40.823, "lng": -73.9511, "name": "Alexander Hamilton Playground Public Restroom", "comment": "Hamilton Place, West 140 to West 141 Streets"
    },
    { "lat": 40.5726, "lng": -73.9831, "name": "West 16th Street Public Restroom", "comment": "Boardwalk at West 16th Street"
    },
    { "lat": 40.6746, "lng": -73.7878, "name": "Sutphin Playground Public Restroom", "comment": "Sutphin Blvd & 125 Avenue"
    },
    { "lat": 40.6569, "lng": -73.9704, "name": "Prospect Park-Lookout Hill-Wellhouse", "comment": ""
    },
    { "lat": 40.8571, "lng": -73.8982, "name": "Slattery Playground Public Restroom", "comment": "East 183 Street, Ryer Avenue, Valentine Avenue"
    },
    { "lat": 40.6349, "lng": -73.8872, "name": "Bayview Playground Public Restroom", "comment": "Seaview Avenue & East 99 Street"
    },
    { "lat": 40.73, "lng": -73.8351, "name": "Triassic Playground Public Restroom", "comment": "Jewel Ave. & Van Wyck Expwy."
    },
    { "lat": 40.8703, "lng": -73.9214, "name": "Isham St. Entrance Public Restroom", "comment": "Seaman Ave. & Isham St."
    },
    { "lat": 40.6057, "lng": -74.0178, "name": "Dyker Beach Park-District HQ", "comment": "Bay 8th Street & Independence Ave."
    },
    { "lat": 40.8999, "lng": -73.8722, "name": "Woodlawn Playground Public Restroom", "comment": "West 239 Street & Van Cortlandt East"
    },
    { "lat": 40.6619, "lng": -73.9144, "name": "Betsy Head Park Public Restroom", "comment": "Livonia Ave & Strauss St"
    },
    { "lat": 40.8343, "lng": -73.8622, "name": "Virginia Playground Public Restroom", "comment": "Virginia Avenue, McGraw Avenue, Cross Bronx Expressway, White Plains Road"
    },
    { "lat": 40.8025, "lng": -73.959, "name": "Morningside Park Ball Fields Public Restroom", "comment": "West 112th Street & Manhattan Avenue"
    },
    { "lat": 40.7021, "lng": -73.9335, "name": "Green Central Knoll Public Restroom", "comment": "49 Evergreen Avenue"
    },
    { "lat": 40.7942, "lng": -73.9527, "name": "Conservatory Garden Women's Public Restroom", "comment": "5th Avenue, 103rd Street to 106th Street"
    },
    { "lat": 40.8719, "lng": -73.906, "name": "Riverbend Playground Public Restroom", "comment": "Bailey Avenue, West Kingsbridge Road"
    },
    { "lat": 40.7716, "lng": -73.9073, "name": "Ditmars Playground Public Restroom", "comment": "23 Avenue to Ditmars Boulevard"
    },
    { "lat": 40.818, "lng": -73.8704, "name": "Soundview Park Playground Public Restroom", "comment": "Metcalf Avenue between Seward and Randall Avenues"
    },
    { "lat": 40.5828, "lng": -74.1232, "name": "High Rock Park Men's Public Restroom", "comment": "Paw Trail near Blue Trail"
    },
    { "lat": 40.6227, "lng": -74.0792, "name": "Rev. Dr. Maggie Howard Playground Public Restroom", "comment": "Tompkins Avenue & Broad Street"
    },
    { "lat": 40.8078, "lng": -73.9251, "name": "Lozada Playground Public Restroom", "comment": "East 135 Street, Willis Avenue, Alexander Avenue"
    },
    { "lat": 40.7264, "lng": -73.8084, "name": "Playground Seventy Five Public Restroom", "comment": "160 Street & 75 Avenue"
    },
    { "lat": 40.829, "lng": -73.8691, "name": "Watson Gleason Playground Public Restroom", "comment": "Gleason Avenue, Rosedale Avenue, Watson Avenue, Nobel Avenue"
    },
    { "lat": 40.6927, "lng": -73.9358, "name": "Eleanor Roosevelt Playground Public Restroom", "comment": "Lewis & DeKalb Avenues"
    },
    { "lat": 40.703, "lng": -73.924, "name": "Maria Hernandez Park Public Restroom", "comment": "Knickerbocker to Irving Avenues, Starr to Suydam Streets"
    },
    { "lat": 40.7106, "lng": -73.9598, "name": "La Guardia Playground Public Restroom", "comment": "Havemeyer, Roebling Streets & South 4"
    },
    { "lat": 40.7473, "lng": -73.922, "name": "Torsney Playground Public Restroom", "comment": "Skillman Avenue & 43 Street"
    },
    { "lat": 40.6231, "lng": -74.1463, "name": "Markham Playground Public Restroom", "comment": "Willowbrook Parkway, Forest Avenue & Houston Street"
    },
    { "lat": 40.6832, "lng": -73.8929, "name": "Upper Highland Playground Public Restroom", "comment": "Heath Pl & Highland Blvd"
    },
    { "lat": 40.9021, "lng": -73.9049, "name": "Vinmont Veteran Park Public Restroom", "comment": "Mosholu Avenue, West 254 Street, Riverdale Avenue, West 256 Street"
    },
    { "lat": 40.6023, "lng": -74.0116, "name": "Bath Beach Park Public Restroom", "comment": "Shore Pkwy. bet. Bay 14 St. and Bay 16 St."
    },
    { "lat": 40.757, "lng": -73.9474, "name": "Vernon Playground Public Restroom", "comment": "21 Street, Bridge Plaza, Vernon Boulevard, East River"
    },
    { "lat": 40.812, "lng": -73.8386, "name": "Ferry Point Park West Public Restroom", "comment": "mid-park, at Hutchinson River Parkway parking lot"
    },
    { "lat": 40.8221, "lng": -73.8599, "name": "Space Time Playground Public Restroom", "comment": "Streetory Avenue, Bolton Avenue, Lafayette Avenue, Underhill Avenue"
    },
    { "lat": 40.8862, "lng": -73.9171, "name": "Seton Park Public Restroom", "comment": "West 135 Street, Independence Avenue, West 232 Street"
    },
    { "lat": 40.8405, "lng": -73.8978, "name": "Crotona Park Pool House", "comment": "1700 Fulton Avenue"
    },
    { "lat": 40.7473, "lng": -73.8086, "name": "Kissena Park -Tennis Courts Public Restroom", "comment": "mid-Park, enter at Rose & Oak Avenues"
    },
    { "lat": 40.754, "lng": -73.9827, "name": "Bryant Park Public Restroom", "comment": "W. 42nd St. & Ave. of the Americas"
    },
    { "lat": 40.7873, "lng": -73.9821, "name": "River Run Playground Public Restroom", "comment": "83rd Street near Riverside Drive"
    },
    { "lat": 40.8525, "lng": -73.8347, "name": "Colucci Playground Public Restroom", "comment": "Hutchinson River Parkway, Wilkinson Avenue, Mayflower Avenue"
    },
    { "lat": 40.5993, "lng": -73.7442, "name": "Lannett Playground Public Restroom", "comment": "Lanett Ave. between Beach 8th St. & Beach 9th St."
    },
    { "lat": 40.772, "lng": -73.7694, "name": "Crocheron Park Public Restroom", "comment": "33rd Rd. & 215th Pl."
    },
    { "lat": 40.7814, "lng": -73.8445, "name": "Poppenhusen Playground Public Restroom", "comment": "20 Avenue between 123 & 124 Streets"
    },
    { "lat": 40.7224, "lng": -73.9912, "name": "Houston St. Playground Public Restroom", "comment": "Stanton St. between Chrystie St. & Forsyth St."
    },
    { "lat": 40.7894, "lng": -73.9619, "name": "Tennis House Public Restroom", "comment": "West Side between 94th and 96th Streets near the West Drive"
    },
    { "lat": 40.6385, "lng": -74.1179, "name": "Corporal Thompson Playground Public Restroom", "comment": "Broadway, Henderson Avenue"
    },
    { "lat": 40.773, "lng": -73.785, "name": "Bayside Fields Public Restroom", "comment": "204 Street & 29 Avenue, Clearview Expressway"
    },
    { "lat": 40.698, "lng": -73.9828, "name": "Golconda Playground  Public Restroom", "comment": "Gold St & Concord St"
    },
    { "lat": 40.7612, "lng": -73.9929, "name": "Mathews-Palmer Playground Public Restroom", "comment": "West 45 Street between 9 & 10 Avenues"
    },
    { "lat": 40.685, "lng": -73.727, "name": "Laurelton West Playground Public Restroom", "comment": "238th St. & 120th Ave."
    },
    { "lat": 40.6635, "lng": -73.9499, "name": "Marc And Jason's Playground Public Restroom", "comment": "Sterling Street & Empire Boulevard"
    },
    { "lat": 40.758, "lng": -73.8247, "name": "Bowne Playground Public Restroom", "comment": "Union Street and Sanford Avenue"
    },
    { "lat": 40.6533, "lng": -74.0192, "name": "Bush Terminal Park Public Restroom", "comment": "Marginal St. & 43rd St"
    },
    { "lat": 40.7361, "lng": -73.8527, "name": "Playground Sixty Two LXII Public Restroom", "comment": "Yellowstone Boulevard between 62 Avenue & 62 Road"
    },
    { "lat": 40.8532, "lng": -73.938, "name": "Bennett Park Public Restroom", "comment": "West 185 Street, Ft Washington Avenue"
    },
    { "lat": 40.6989, "lng": -73.8585, "name": "Seuffert Bandshell Public Restroom", "comment": "West Main Drive to eastern side of golf course"
    },
    { "lat": 40.7544, "lng": -73.8895, "name": "Travers Park Public Restroom", "comment": "78 Street, south of Northern Boulevard"
    },
    { "lat": 40.6613, "lng": -73.9893, "name": "Slope Park Playground Public Restroom", "comment": "6th Avenue Between 18th & 19th Sts"
    },
    { "lat": 40.6565, "lng": -73.9548, "name": "Winthrop Playground Public Restroom", "comment": "Winthrop St between Bedford Ave & Rogers Ave"
    },
    { "lat": 40.7994, "lng": -73.9662, "name": "Bloomingdale Playground Public Restroom", "comment": "Amsterdam Avenue, West 104 & West 105 Streets"
    },
    { "lat": 40.535, "lng": -74.2085, "name": "Bloomingdale Playground Public Restroom", "comment": "Richmond Pkwy, Bloomingdale Rd., Lenevar Ave"
    },
    { "lat": 40.7919, "lng": -73.8083, "name": "Whitestone Playground Public Restroom", "comment": "12 Avenue & 153 Street"
    },
    { "lat": 40.7796, "lng": -73.9227, "name": "Charybdis Playground Public Restroom", "comment": "Shore Boulevard opposite 23 Road"
    },
    { "lat": 40.8291, "lng": -73.9443, "name": "Carmansville Playground Public Restroom", "comment": "Amsterdam Avenue, West 151 to West 152 Streets"
    },
    { "lat": 40.7126, "lng": -73.9886, "name": "Little Flower Playground Public Restroom", "comment": "Madison Street opposite Jefferson Street"
    },
    { "lat": 40.7709, "lng": -73.7376, "name": "Admiral Playground Public Restroom", "comment": "Little Neck Parkway, 42 to 43 Avenues"
    },
    { "lat": 40.6996, "lng": -73.8131, "name": "Howard Von Dohlen Playground Public Restroom", "comment": "Howard Von Dohlen Playground"
    },
    { "lat": 40.7366, "lng": -73.7707, "name": "Cunningham Park Fields Public Restroom", "comment": "mid-Park on 73rd Ave. near Fields 15 and 16"
    },
    { "lat": 40.7188, "lng": -73.8846, "name": "Juniper Valley Park Running Track Public Restroom", "comment": "Enter at 71st Street and Juniper Blvd. South"
    },
    { "lat": 40.6605, "lng": -73.9636, "name": "Lincoln Road Playground Public Restroom", "comment": "Lincoln Rd. & Ocean Ave."
    },
    { "lat": 40.8415, "lng": -73.9068, "name": "Claremont Park North Public Restroom", "comment": "mid-park, E. Mt. Eden Ave between Monroe Ave & Topping Ave"
    },
    { "lat": 40.7736, "lng": -73.945, "name": "Catbird Playground Public Restroom", "comment": "Gracie Square & East End Avenue"
    },
    { "lat": 40.6664, "lng": -73.9276, "name": "Lincoln Terrace Park / Arthur S. Somers Park Public Restroom", "comment": "Rochester Avenue between President Street and Carroll Street"
    },
    { "lat": 40.6818, "lng": -73.8397, "name": "Police Officer Nicholas Demutiis Park Public Restroom", "comment": "102 Street & Liberty Avenue"
    },
    { "lat": 40.5225, "lng": -74.1858, "name": "E.M.T. Christopher J. Prescott Playground Public Restroom", "comment": "Hylan Boulevard & Huguenot Avenue"
    },
    { "lat": 40.6131, "lng": -74.0132, "name": "Dyker Playground Public Restroom", "comment": "86th Street & 14th Avenue"
    },
    { "lat": 40.6987, "lng": -73.7399, "name": "East Springfield Playground Public Restroom", "comment": "115 Road between 218 & 219 Streets"
    },
    { "lat": 40.5896, "lng": -73.921, "name": "Seba Playground Public Restroom", "comment": "Gerritsen Ave. & Seba Ave."
    },
    { "lat": 40.7619, "lng": -73.8842, "name": "Gorman Playground Public Restroom", "comment": "30 Avenue between 84 & 85 Streets"
    },
    { "lat": 40.7159, "lng": -73.9998, "name": "Columbus Park Pavilion", "comment": "Bayard Street between Baxter and Mulberry Streets"
    },
    { "lat": 40.7824, "lng": -73.7773, "name": "Bay Terrace Playground Public Restroom", "comment": "23 Avenue & 212 Street"
    },
    { "lat": 40.7481, "lng": -73.9687, "name": "Robert Moses Playground Public Restroom", "comment": "1 Avenue, East 41 to East 42 Streets"
    },
    { "lat": 40.7549, "lng": -73.8552, "name": "Louis Armstrong Playground Public Restroom", "comment": "37 Avenue between 112 & 113 Streets"
    },
    { "lat": 40.6087, "lng": -74.1195, "name": "Christopher J. Igneri Playground Public Restroom", "comment": "Schmidts Lane & Manor Road"
    },
    { "lat": 40.7208, "lng": -73.9501, "name": "McCarren Park Play Center PR", "comment": "McCarren Pool & Play Center"
    },
    { "lat": 40.6897, "lng": -73.9996, "name": "Van Voorhees Playground Public Restroom", "comment": "Congress, Columbia, West/South BQE"
    },
    { "lat": 40.7757, "lng": -73.9439, "name": "Carl Schurz Promenade Public Restroom", "comment": "East 87th Street & East End Avenue"
    },
    { "lat": 40.8617, "lng": -73.8908, "name": "Rose Hill Park Public Restroom", "comment": "Webster Avenue, Harlem River, East Fordham Road"
    },
    { "lat": 40.8377, "lng": -73.908, "name": "Claremont Park South Public Restroom", "comment": "Mount Eden Parkway & Morris Avenue"
    },
    { "lat": 40.7571, "lng": -73.7715, "name": "Marie Curie Playground Public Restroom", "comment": "211 & Oceana Streets, 46 Avenue"
    },
    { "lat": 40.6738, "lng": -73.9438, "name": "Brower Park Public Restroom", "comment": "Brooklyn Ave & Prospect Pl"
    },
    { "lat": 40.8358, "lng": -73.9034, "name": "Gouverneur Playground Public Restroom", "comment": "3rd Avenue, St. Paul's Place, East 170 Street"
    },
    { "lat": 40.8517, "lng": -73.8247, "name": "Pelham Bay Nature Center", "comment": "Bruckner Blvd. and Wilkinson Avenue"
    },
    { "lat": 40.677, "lng": -73.9785, "name": "Park Slope Playground Public Restroom", "comment": "Berkeley Street & Lincoln Place"
    },
    { "lat": 40.8695, "lng": -73.8766, "name": "French Charley's Playground Public Restroom", "comment": "East 204 Street & Webster Avenue entrance; south of playground"
    },
    { "lat": 40.8173, "lng": -73.9048, "name": "Abigail Playground Public Restroom", "comment": "East 156 Street, Tinton Avenue"
    },
    { "lat": 40.8663, "lng": -73.7947, "name": "Pelham Bay Park-ORCHARD BEACH/HQ", "comment": "Park Dr cul de sac, Orchard Beach "
    },
    { "lat": 40.7362, "lng": -73.8141, "name": "Pomonok Playground Public Restroom", "comment": "Kissena Boulevard, 65 Avenue"
    },
    { "lat": 40.7449, "lng": -73.7096, "name": "Playground Eighty LXXX Public Restroom", "comment": "80th Ave. between 261st St. & 262nd. St."
    },
    { "lat": 40.8389, "lng": -73.946, "name": "Lily Brown Playground Public Restroom", "comment": "West 162 Street, east of Riverside Drive"
    },
    { "lat": 40.6203, "lng": -74.1635, "name": "Jennifer's Playground Field House", "comment": "Regis Dr between Farragut Ave & Elson Ct"
    },
    { "lat": 40.711, "lng": -73.9974, "name": "Alfred E. Smith Playground Public Restroom", "comment": "Monroe Street & Catherine Street"
    },
    { "lat": 40.8685, "lng": -73.9313, "name": "Fort Washington Park Dyckman St. Public Restroom", "comment": "338 Dyckman Street"
    },
    { "lat": 40.5718, "lng": -73.9988, "name": "West 33rd Street Public Restroom", "comment": "Boardwalk at West 33rd Street"
    },
    { "lat": 40.7419, "lng": -73.74, "name": "Alley Pond Park Public Restroom", "comment": "Entrance off Grand Central Parkway, includes athletic fields and picnic areas"
    },
    { "lat": 40.84, "lng": -73.8953, "name": "Cary Leeds Tennis Center", "comment": "Crotona Avenue & Crotona Park North"
    },
    { "lat": 40.6321, "lng": -74.0387, "name": "79th Street Entrance Public Restroom", "comment": "Shore Road & 78th Street"
    },
    { "lat": 40.8432, "lng": -73.8773, "name": "River Park Playground Public Restroom", "comment": "East 180th Street, Boston Road"
    },
    { "lat": 40.7833, "lng": -73.9867, "name": "Classic Playground Men", "comment": "Along Hudson River, b/w W 75th & W 76th St."
    },
    { "lat": 40.7167, "lng": -73.9941, "name": "Sara D. Roosevelt Park Track Public Restroom", "comment": "Hester Street between Forsyth St. & Christie St."
    },
    { "lat": 40.7583, "lng": -73.9003, "name": "St. Michael's Playground Public Restroom", "comment": "30 - 31 Avenues, Boody Street and BQE"
    },
    { "lat": 40.8445, "lng": -73.8947, "name": "Walter Gladwin Park Playground Public Restroom", "comment": "Corner of East 175 Street & Arthur Avenue"
    },
    { "lat": 40.7747, "lng": -73.9235, "name": "Triborough Bridge Playground B Public Restroom", "comment": "Hoyt Avenue, 21 to 23 Streets"
    },
    { "lat": 40.814, "lng": -73.9212, "name": "Clark Playground Public Restroom", "comment": "3 Avenue, East 144 Street, East 146 Street"
    },
    { "lat": 40.7463, "lng": -73.7583, "name": "Tall Oak Playground Public Restroom", "comment": "64 Avenue, 218 & 219 Streets"
    },
    { "lat": 40.7467, "lng": -73.8386, "name": "South Of Fountain Of The Planets Public Restroom", "comment": "mid-Park, between Avenue of Commerce & Avenue of Progress"
    },
    { "lat": 40.7159, "lng": -73.9752, "name": "Brian Watkins Tennis Center Public Restroom", "comment": "East River Park at Broome Street"
    },
    { "lat": 40.8441, "lng": -73.8814, "name": "Vidalia Park Public Restroom", "comment": "Vyse & Daly Avenues between West 179-180 Streets"
    },
    { "lat": 40.7007, "lng": -73.8552, "name": "Forest Park Visitor Center", "comment": "Woodhaven Boulevard and Forest Park Drive"
    },
    { "lat": 40.5901, "lng": -74.1879, "name": "Schmul Park Public Restroom", "comment": "Wild Avenue, Pearson Street"
    },
    { "lat": 40.7356, "lng": -73.9593, "name": "Greenpoint Playground Public Restroom", "comment": "Franklin St. bet. Commercial St. and Dupont St."
    },
    { "lat": 40.8464, "lng": -73.9408, "name": "J. Hood Wright Recreation Center", "comment": "Ft. Washington & Haven Avenues, West 173 Street"
    },
    { "lat": 40.783, "lng": -73.8068, "name": "Clintonville Playground Public Restroom", "comment": "Clintonville Street, 17 Road & 17 Avenue"
    },
    { "lat": 40.6867, "lng": -73.981, "name": "Sixteen Sycamores Playground Public Restroom", "comment": "Schermerhorn & Nevins Street"
    },
    { "lat": 40.833, "lng": -73.9033, "name": "Drew Playground Public Restroom", "comment": "Fulton Avenue, East 169 Street"
    },
    { "lat": 40.5859, "lng": -74.1008, "name": "Gen. Douglas MacArthur Park Public Restroom", "comment": "254 JEFFERSON STREET"
    },
    { "lat": 40.8204, "lng": -73.9521, "name": "Jacob H. Schiff Playground Public Restroom", "comment": "Amsterdam Avenue, West 136 Street"
    },
    { "lat": 40.7551, "lng": -73.9496, "name": "QueensBridge Park-Field House", "comment": "QueensBridge Park"
    },
    { "lat": 40.5743, "lng": -73.9716, "name": "West 2nd Street Public Restroom", "comment": ""
    },
    { "lat": 40.6561, "lng": -73.9062, "name": "Osborn Playground Public Restroom", "comment": "Linden Boulevard & Osborn Street"
    },
    { "lat": 40.577, "lng": -73.9441, "name": "Manhattan Beach Bathhouse Public Restroom", "comment": "Oriental Blvd. & Hastings St."
    },
    { "lat": 40.8191, "lng": -73.8783, "name": "Soundview Park Dog Run Public Restroom", "comment": "Lafayette Avenue between Colgate and Boynton Avenues"
    },
    { "lat": 40.6914, "lng": -73.8536, "name": "Equity Playground Public Restroom", "comment": "90 Street, 88 & 89 Avenues"
    },
    { "lat": 40.6866, "lng": -73.9394, "name": "Raymond Bush Playground Public Restroom", "comment": "Sumner Avenue, Madison Street"
    },
    { "lat": 40.7682, "lng": -73.9946, "name": "De Witt Clinton Park Public Restroom", "comment": "West 52 to West 54 Streets, 11 to 12 Avenues"
    },
    { "lat": 40.577, "lng": -73.9702, "name": "Century Playground Public Restroom", "comment": "Brighton Beach Avenue & West 2 Street"
    },
    { "lat": 40.6656, "lng": -73.9716, "name": "The Picnic House", "comment": "Long Meadow at West Dr. & 5th St."
    },
    { "lat": 40.7207, "lng": -73.8774, "name": "Juniper North Playground Tennis Public Restroom", "comment": "62nd Avenue & 80th Street"
    },
    { "lat": 40.8469, "lng": -73.8615, "name": "Matthews Muliner Playground Public Restroom", "comment": "Delancy Place, Muliner Avenue, Matthews Avenue"
    },
    { "lat": 40.8209, "lng": -73.9467, "name": "Arlington 'Ollie' Edinboro Playground Public Restroom", "comment": "West 140 Street & St. Nicholas Avenue"
    },
    { "lat": 40.7355, "lng": -73.8572, "name": "Real Good Playground Public Restroom", "comment": "LIE, 99 Street & 62 Avenue"
    },
    { "lat": 40.8284, "lng": -73.9297, "name": "Joseph Yancey Track & Field Public Restroom", "comment": "East 161st Street, near Major Deegan Expwy."
    },
    { "lat": 40.774, "lng": -73.9665, "name": "Kerbs Boathouse (Model Boat Pond)", "comment": "Conservatory Water, East Side at 74th Street."
    },
    { "lat": 40.8209, "lng": -73.9119, "name": "Flynn Playground Public Restroom", "comment": "3 Avenue, East 158 Street, Brook Avenue, East 157 Street"
    },
    { "lat": 40.6801, "lng": -73.7751, "name": "North Rochdale Playground Public Restroom", "comment": "Baisley Boulevard & Bedell Street"
    },
    { "lat": 40.5881, "lng": -73.9903, "name": "Calvert Vaux Playground Public Restroom", "comment": "Cropsey Ave. Between 27th Ave. & Bay 46th St."
    },
    { "lat": 40.6492, "lng": -73.914, "name": "Railroad Playground Public Restroom", "comment": "Ditmas Avenue between East 91 & East 92 Streets"
    },
    { "lat": 40.6266, "lng": -74.0167, "name": "McKinley Park Public Restroom", "comment": "Fort Hamilton Parkway, 73 to 78 Streets, 7 Avenue"
    },
    { "lat": 40.6847, "lng": -73.9878, "name": "Nicholas Naquan Heyward Jr. Park Public Restroom", "comment": "Wyckoff Street between Bond & Hoyt Streets"
    },
    { "lat": 40.768, "lng": -73.9219, "name": "Athens Square Public Restroom", "comment": "29 Street, 30 Street, 30 Avenue, Newtown Avenue"
    },
    { "lat": 40.7372, "lng": -73.8457, "name": "World's Fair Playground Public Restroom", "comment": "62nd Drive And Grand Central Pkwy Service Rd"
    },
    { "lat": 40.5023, "lng": -74.2517, "name": "Conference House Park-Visitor Center & Lenape Gallery", "comment": "7455 Hylan Blvd"
    },
    { "lat": 40.6916, "lng": -73.9325, "name": "Jesse Owens Playground Public Restroom", "comment": "Stuyvesant & Lafayette Avenues"
    },
    { "lat": 40.8255, "lng": -73.9009, "name": "Behagen Playground Public Restroom", "comment": "Tinton Avenue, East 165 Street, Union Avenue, East 166 Street"
    },
    { "lat": 40.7577, "lng": -73.9335, "name": "Dutch Kills Playground Public Restroom", "comment": "Crescent Street between 36 Avenue & 37 Avenue"
    },
    { "lat": 40.8584, "lng": -73.908, "name": "Aqueduct Walk Public Restroom", "comment": "Aqueduct Ave. E & W. 182nd St."
    },
    { "lat": 40.7592, "lng": -73.9914, "name": "McCaffrey Playground Public Restroom", "comment": "West 43 Street, 8 & 9 Avenues"
    },
    { "lat": 40.8654, "lng": -73.8985, "name": "St. James Park Golden Age Center", "comment": "Jerome Avenue, Morris Avenue, East 191 Street, Creston Avenue, East 192 Street,*"
    },
    { "lat": 40.8608, "lng": -73.9328, "name": "Fort Tryon Park Café", "comment": "1 Margaret Corbin Drive"
    },
    { "lat": 40.7243, "lng": -73.9856, "name": "McKinley Playground Public Restroom", "comment": "Avenue A, East 3-East 4 Streets"
    },
    { "lat": 40.8196, "lng": -73.9362, "name": "Brigadier General Charles Young Playground Public Restroom", "comment": "West 144 Street & Lenox Avenue"
    },
    { "lat": 40.61, "lng": -73.9696, "name": "Colonel David Marcus Playground Public Restroom", "comment": "Ocean Parkway, Avenue P, East 3 Street"
    },
    { "lat": 40.8279, "lng": -73.9399, "name": "Playground One Fifty Two CLII Public Restroom", "comment": "West 152 Street & Bradhurst Avenue"
    },
    { "lat": 40.5829, "lng": -74.1243, "name": "High Rock Park Women’s Public Restroom", "comment": ""
    },
    { "lat": 40.7444, "lng": -73.8869, "name": "Frank D. O'Connor Playground Public Restroom", "comment": "Broadway & 78 Street"
    },
    { "lat": 40.7829, "lng": -73.8236, "name": "Harvey Park Playground Public Restroom", "comment": "South of Park, near 144th St & 20th Ave"
    },
    { "lat": 40.8343, "lng": -73.8779, "name": "Captain William Harry Thompson Public Restroom", "comment": "East 174 Street, Stratford Avenue, Bronx River Avenue"
    },
    { "lat": 40.7479, "lng": -73.7762, "name": "Saul Weprin Playground Public Restroom", "comment": "53 Avenue between 201 & 202 Streets"
    },
    { "lat": 40.6162, "lng": -74.0395, "name": "96th Street Entrance Public Restroom", "comment": "Shore Road & 95th Street"
    },
    { "lat": 40.8472, "lng": -73.9312, "name": "Quisqueya Playground Public Restroom", "comment": "W. 180th St. & Amsterdam Ave."
    },
    { "lat": 40.7692, "lng": -73.9808, "name": "Merchants' Gate Public Restroom", "comment": "West 61st Street by Columbus Circle"
    },
    { "lat": 40.7256, "lng": -74.0025, "name": "Vesuvio Playground Public Restroom", "comment": "Spring & Thompson Streets"
    },
    { "lat": 40.6859, "lng": -73.7562, "name": "Locust Manor Playground Public Restroom", "comment": "192 Street, 121 Avenue"
    },
    { "lat": 40.7229, "lng": -73.8271, "name": "Albert H. Mauro Playground Public Restroom", "comment": "Park Drive East & 73 Terrace"
    },
    { "lat": 40.6809, "lng": -73.9948, "name": "Robert Acito Parkhouse", "comment": "Court & Smith Streets"
    },
    { "lat": 40.5825, "lng": -73.9644, "name": "Grady Playground Public Restroom", "comment": "Brighton 4th St. & Brighton 4th Rd."
    },
    { "lat": 40.751, "lng": -73.8338, "name": "College Point Blvd Soccer Fields Public Restroom", "comment": "Fowler Avenue & College Point Blvd, behind Al Oerter Recreation Center"
    },
    { "lat": 40.5746, "lng": -73.9645, "name": "Brighton 2nd Street Public Restroom", "comment": "Brighton 2nd Street & Boardwalk"
    },
    { "lat": 40.6707, "lng": -73.8711, "name": "Cypress Hills Playground Public Restroom", "comment": "Blake & Euclid Avenues"
    },
    { "lat": 40.7472, "lng": -73.9489, "name": "Murray Playground Public Restroom", "comment": "21 Street, 45 Avenue, 11 Street, 45 Road"
    },
    { "lat": 40.7653, "lng": -73.941, "name": "Rainey Park Playground Public Restroom", "comment": "Vernon Boulevard, 33 Road, 34 Street, East River"
    },
    { "lat": 40.7293, "lng": -73.8798, "name": "Crowley Playground Public Restroom", "comment": "57 Avenue & 83 Street"
    },
    { "lat": 40.6408, "lng": -73.9176, "name": "Curtis Playground Public Restroom", "comment": "Foster Avenue between East 81 and East 82 Streets"
    },
    { "lat": 40.8606, "lng": -73.8712, "name": "Waring Playground Public Restroom", "comment": "Bronx Park East between Waring Avenure and Thwaites Place"
    },
    { "lat": 40.6816, "lng": -73.9592, "name": "Crispus Attucks Playground Public Restroom", "comment": "Fulton Street & Classon Avenue"
    },
    { "lat": 40.6634, "lng": -73.9767, "name": "Lena Horne Bandshell", "comment": "Prospect Park W & 11th St"
    },
    { "lat": 40.6903, "lng": -73.8395, "name": "Maurice A Fitzgerald Playground Public Restroom", "comment": "Atlantic Avenue & 106 Street"
    },
    { "lat": 40.6042, "lng": -74.1586, "name": "Willowbrook Park-Boathouse", "comment": "Eton Pl. at Willowbrook Lake"
    },
    { "lat": 40.7307, "lng": -73.9983, "name": "Washington Square Park Public Restroom", "comment": "5 Avenue, Waverly Place, West 4 & MacDougal Streets."
    },
    { "lat": 40.8247, "lng": -73.9348, "name": "Frederick Johnson Playground Public Restroom", "comment": "7 Avenue, West 150-151 Streets"
    },
    { "lat": 40.7935, "lng": -73.8514, "name": "MacNeil Playground Public Restroom", "comment": "East of paved path running north from 119th Street"
    },
    { "lat": 40.7296, "lng": -73.7736, "name": "Cunningham Park Tennis House Public Restroom", "comment": "196-00 Union Turnpike"
    },
    { "lat": 40.8698, "lng": -73.7904, "name": "Hunter Island Picnic Area Public Restroom", "comment": "at Orchard Beach, near Kazimiroff Nature Trail"
    },
    { "lat": 40.7361, "lng": -73.7773, "name": "Farm Playground Public Restroom", "comment": "73 Avenue, 195 Street & 196 Place"
    },
    { "lat": 40.6626, "lng": -73.9407, "name": "Hamilton Metz Field Public Restroom", "comment": "Albany, East New York, Lefferts Avenues"
    },
    { "lat": 40.8003, "lng": -73.9503, "name": "Martin Luther King, Jr. Playground Public Restroom", "comment": "Lenox Avenue, West 113 to West 114 Streets"
    },
    { "lat": 40.8368, "lng": -73.8718, "name": "Noble Playground Public Restroom", "comment": "Nobel Avenue, Bronx River Avenue, Bronx River Parkway, Cross Bronx Expressway"
    },
    { "lat": 40.7834, "lng": -73.9848, "name": "Neufeld (Elephant) Playground Public Restroom", "comment": "76th Street & Riverside Drive"
    },
    { "lat": 40.6691, "lng": -73.7887, "name": "Baisley Park South Playground Public Restroom", "comment": "150th Street & 130th Avenue"
    },
    { "lat": 40.6665, "lng": -73.8625, "name": "Pink Playground Public Restroom", "comment": "Stanley Avenue & Eldert Lane"
    },
    { "lat": 40.5924, "lng": -73.9358, "name": "Yak Playground Public Restroom", "comment": "Avenue Y between Coyle & Batchelder Streets"
    },
    { "lat": 40.8805, "lng": -73.8617, "name": "Agnes Haywood Playground Public Restroom", "comment": "East 215 Street, Barnes Avenue, East 216 Street"
    },
    { "lat": 40.7477, "lng": -73.854, "name": "Corona Golf Playground Public Restroom", "comment": "109 Street between 46-47 Avenues"
    },
    { "lat": 40.7011, "lng": -73.9954, "name": "Squibb Park Public Restroom", "comment": "Columbia Heights, Middagh Street"
    },
    { "lat": 40.7484, "lng": -73.8337, "name": "Lawrence Playground Public Restroom", "comment": "College Point Boulevard and Lawrence Street"
    },
    { "lat": 40.6083, "lng": -73.7646, "name": "Westbourne Playground Public Restroom", "comment": "Mott Avenue & Bay 25 Street"
    },
    { "lat": 40.7134, "lng": -73.9545, "name": "Jaime Campiz Playground Public Restroom", "comment": "Hope Street & Metropolitan Avenue"
    },
    { "lat": 40.865, "lng": -73.8947, "name": "Poe Park Visitor Center", "comment": "Grand Concourse at E. 193rd St"
    },
    { "lat": 40.7172, "lng": -73.9769, "name": "Baruch Playground Public Restroom", "comment": "Stanton St. & Baruch Pl."
    },
    { "lat": 40.7777, "lng": -73.9841, "name": "Matthew P. Sapolin Playground Public Restroom", "comment": "West End Avenue & West 70 Street"
    },
    { "lat": 40.7594, "lng": -73.9589, "name": "Twenty-Four Sycamores Park Public Restroom", "comment": "FDR Drive, East 60 to East 61 Streets & York Avenue"
    },
    { "lat": 40.6741, "lng": -73.7744, "name": "Vic Hanson Field House-Building", "comment": "133-39 Guy R. Brewer Boulevard"
    },
    { "lat": 40.7153, "lng": -73.964, "name": "William Sheridan Playground Public Restroom", "comment": "Wythe Avenue, Berry & Grand Streets"
    },
    { "lat": 40.7147, "lng": -73.9891, "name": "Seward Park Public Restroom", "comment": "Jefferson & Canal Streets"
    },
    { "lat": 40.6805, "lng": -73.9728, "name": "Dean Playground Public Restroom", "comment": "Bergen St. Between 6th Ave. & Carlton Ave."
    },
    { "lat": 40.5806, "lng": -73.8261, "name": "Beach 106th Street Public Restroom", "comment": "Boardwalk at Beach 106th Street"
    },
    { "lat": 40.5737, "lng": -73.9927, "name": "Surf Playground Public Restroom", "comment": "West 27 Street & Surf Avenue"
    },
    { "lat": 40.797, "lng": -73.9677, "name": "Frederick Douglass Playground Public Restroom", "comment": "West 100-101 Street Amsterdam Avenue"
    },
    { "lat": 40.6827, "lng": -73.9307, "name": "El Shabazz Playground Public Restroom", "comment": "Malcolm X Blvd between Mason St & Mac Donough St"
    },
    { "lat": 40.81, "lng": -73.9559, "name": "Playground 123 Public Restroom", "comment": "West 123rd Street & Morningside Avenue"
    },
    { "lat": 40.9009, "lng": -73.8927, "name": "Stables Area Public Restroom", "comment": "Rockwood Circle near John Muir Trailhead"
    },
    { "lat": 40.8217, "lng": -73.9417, "name": "Renaissance Playground Public Restroom", "comment": "West 144 Street, between 7 & 8 Avenues"
    },
    { "lat": 40.7344, "lng": -73.7962, "name": "Fresh Meadows Playground Public Restroom", "comment": "67 Avenue & 173 Street"
    },
    { "lat": 40.7364, "lng": -73.9899, "name": "Union Square Pavilion", "comment": "20 Union Square W"
    },
    { "lat": 40.7059, "lng": -73.9472, "name": "Sternberg Park Public Restroom", "comment": "Montrose Avenue, Boerum, Lorimer, Leonard Streets"
    },
    { "lat": 40.7517, "lng": -73.8432, "name": "Passerelle Building", "comment": "across from outdoor Tennis Courts, at Meridian Road"
    },
    { "lat": 40.7305, "lng": -73.8851, "name": "Queens Vietnam Veterans Memorial", "comment": "79th St. & Grand Ave."
    },
    { "lat": 40.7356, "lng": -73.9821, "name": "Augustus St. Gaudens Playground Public Restroom", "comment": "East 19 to East 20 Streets, 2 Avenue"
    },
    { "lat": 40.8578, "lng": -73.922, "name": "Sherman Creek Park Public Restroom", "comment": "Dyckman St., 10th Ave, and Harlem River Drive"
    },
    { "lat": 40.6923, "lng": -73.9772, "name": "Fort Greene Playground Public Restroom", "comment": "St. Edwards Street & Willoughby Street"
    },
    { "lat": 40.7563, "lng": -73.8745, "name": "Northern Playground Public Restroom", "comment": "Northern Boulevard & 93 Street"
    },
    { "lat": 40.5889, "lng": -73.7891, "name": "Beach 59th St Playground Public Restroom", "comment": "Boardwalk & Beach 59-60 Streets"
    },
    { "lat": 40.7775, "lng": -73.9026, "name": "Woodtree Playground Public Restroom", "comment": "20 Avenue, 37 Street, 38 Street"
    },
    { "lat": 40.675, "lng": -73.9622, "name": "Stroud Playground Public Restroom", "comment": "Classon Avenue & Sterling Place"
    },
    { "lat": 40.6802, "lng": -73.9273, "name": "Jackie Robinson Park Playground Public Restroom", "comment": "Malcolm X Boulevard between Chauncey and Marion Streets"
    },
    { "lat": 40.7407, "lng": -73.8412, "name": "Ederle Terrace Public Restroom", "comment": "17 Ederle Promenade"
    },
    { "lat": 40.8388, "lng": -73.8457, "name": "The Pearly Gates Public Restroom", "comment": "Tratman Avenue between St. Peter's Avenue & Rowland Street"
    },
    { "lat": 40.7784, "lng": -73.9677, "name": "The Ramble Shed", "comment": "The Ramble Shed, Mid-Park south of 79th St Tranverse"
    },
    { "lat": 40.7488, "lng": -73.8972, "name": "Hart Playground Public Restroom", "comment": "37 Avenue, west of 69 Street"
    },
    { "lat": 40.7358, "lng": -73.8385, "name": "Meadow Lake Boathouse", "comment": "Boathouse Bridge & Meadow Lake Dr"
    },
    { "lat": 40.7489, "lng": -73.8618, "name": "Park Of The Americas Public Restroom", "comment": "104 Street & 41 Avenue"
    },
    { "lat": 40.8502, "lng": -73.89, "name": "Quarry Ballfields Public Restroom", "comment": "Quarry Road, East 181 Street, Oak Place & Hughes Avenue"
    },
    { "lat": 40.6814, "lng": -73.7872, "name": "Baisley Pond Park Playground Public Restroom", "comment": "119th Avenue and 155th Street"
    },
    { "lat": 40.7819, "lng": -73.9787, "name": "Tecumseh Playground Public Restroom", "comment": "West 77 Street & Amsterdam Avenue"
    },
    { "lat": 40.6147, "lng": -74.0739, "name": "De Matti Park Field House", "comment": "Tompkins Avenue, Chestnut Avenue"
    },
    { "lat": 40.8852, "lng": -73.8906, "name": "Classic Playground Public Restroom", "comment": "Van Cortlandt Park South and Gouverneur Avenue"
    },
    { "lat": 40.7837, "lng": -73.9864, "name": "Classic Playground Public Restroom", "comment": "75th Street near the river"
    },
    { "lat": 40.7272, "lng": -73.9043, "name": "Virginia Principe Playground Public Restroom", "comment": "Maurice, Borden, 54 Avenues, 63 Street"
    },
    { "lat": 40.7392, "lng": -73.7651, "name": "210 St Playground Public Restroom", "comment": "210 Street & 73 Avenue"
    },
    { "lat": 40.631, "lng": -74.1651, "name": "The Big Park Public Restroom", "comment": "Grandview Avenue, Continental Place"
    },
    { "lat": 40.6951, "lng": -73.9186, "name": "Heckscher Playground Public Restroom", "comment": "Grove Street to Linden Street"
    },
    { "lat": 40.7157, "lng": -73.8011, "name": "Joseph Austin Playground Public Restroom", "comment": "Grand Central Parkway & 164 Place"
    },
    { "lat": 40.793, "lng": -73.919, "name": "Randall's Island Tennis Center", "comment": "Sunken Meadow Loop"
    },
    { "lat": 40.5754, "lng": -73.9729, "name": "Asser Levy Park Public Restroom", "comment": "Boardwalk, Surf, Sea Breeze Avenues, Ocean Parkway"
    },
    { "lat": 40.6024, "lng": -74.0023, "name": "Benson Playground Public Restroom", "comment": "Bath Avenue between Bay 22 & Bay 23 Streets"
    },
    { "lat": 40.8595, "lng": -73.8929, "name": "Webster Playground Public Restroom", "comment": "E. 188 St. between Webster Ave. And Park Ave."
    },
    { "lat": 40.7618, "lng": -73.7354, "name": "Louis Pasteur Park Public Restroom", "comment": "248 Street & 51 Avenue"
    },
    { "lat": 40.6669, "lng": -73.9737, "name": "Litchfield Villa", "comment": "95 Prospect Park West"
    },
    { "lat": 40.838, "lng": -73.831, "name": "Bufano Park Public Restroom", "comment": "La Salle Avenue, Edison Avenue, Bradford Avenue, Waterbury Avenue"
    },
    { "lat": 40.7105, "lng": -73.8201, "name": "Hoover - Manton Playgrounds Public Restroom", "comment": "Manton Street & 83 Avenue"
    },
    { "lat": 40.7911, "lng": -73.9596, "name": "North Meadow Recreation Center", "comment": "Mid-park at 97th Street"
    },
    { "lat": 40.6831, "lng": -73.8079, "name": "Frederick B. Judge Playground Public Restroom", "comment": "111 Avenue, 134 & 135 Streets, Lincoln Street"
    },
    { "lat": 40.793, "lng": -73.9431, "name": "Poor Richard's Playground Public Restroom", "comment": "East 109 Street between 2 & 3 Avenues"
    },
    { "lat": 40.881, "lng": -73.9206, "name": "Henry Hudson Park Public Restroom", "comment": "Palisade Avenue, Kappock Street & Independence Avenue"
    },
    { "lat": 40.6165, "lng": -74.1046, "name": "Senior Park Public Restroom", "comment": "Clove Road and Victory Blvd."
    },
    { "lat": 40.7573, "lng": -73.8783, "name": "Playground Ninety Public Restroom", "comment": "Northern Boulevard & 90 Street"
    },
    { "lat": 40.7308, "lng": -73.8061, "name": "Emerald Playground Public Restroom", "comment": "164 Street between Jewel & 71 Avenues"
    },
    { "lat": 40.7204, "lng": -73.8597, "name": "The Painter's Playground Public Restroom", "comment": "Alderton Street from Dieterle to Elwell Crescents"
    },
    { "lat": 40.7188, "lng": -73.9019, "name": "Reiff Playground Public Restroom", "comment": "Fresh Pond Road, 63 Street, 59 Drive"
    },
    { "lat": 40.5716, "lng": -73.9923, "name": "West 27th Street Public Restroom", "comment": "Boardwalk at West 27th Street"
    },
    { "lat": 40.7684, "lng": -73.9771, "name": "Central Park-Heckscher Public Restroom", "comment": "Heckscher Playground"
    },
    { "lat": 40.5924, "lng": -74.0636, "name": "South Beach Playground Public Restroom", "comment": "Doty Ave & Father Capodanno Blvd"
    },
    { "lat": 40.5955, "lng": -74.0815, "name": "Old Town Playground Public Restroom", "comment": "Parkinson Avenue, Kramer Street"
    },
    { "lat": 40.6892, "lng": -73.9717, "name": "Edmonds Playground Public Restroom", "comment": "DeKalb Avenue, Adelphi Street"
    },
    { "lat": 40.5979, "lng": -73.9468, "name": "Galapo Playground Public Restroom", "comment": "Bedford Avenue, Gravesend Neck Road"
    },
    { "lat": 40.8149, "lng": -73.9622, "name": "Claremont (Dolphin) Playground Public Restroom", "comment": "124th Street behind Grant's Tomb"
    },
    { "lat": 40.5807, "lng": -73.8305, "name": "Seaside Playground Public Restroom", "comment": "Rockaway Beach Boulevard, B109-B110 Streets"
    },
    { "lat": 40.7855, "lng": -73.951, "name": "Samuel Seabury Playground Public Restroom", "comment": "Lexington Avenue, East 95 to East 96 Streets"
    },
    { "lat": 40.6846, "lng": -73.7287, "name": "Delphin H. Greene Playground Public Restroom", "comment": "121 Avenue & 237 Street"
    },
    { "lat": 40.8275, "lng": -73.9284, "name": "Elston Gene Howard Field Public Restroom", "comment": "mid-park, enter at East 161st Street & River Ave."
    },
    { "lat": 40.7047, "lng": -74.0034, "name": "PIER 15", "comment": "FDR Drive & Fletcher St."
    },
    { "lat": 40.6314, "lng": -74.0129, "name": "8th Ave. & 66th St. Public Restroom", "comment": "8th Ave. between 66th St. & 67th St."
    },
    { "lat": 40.6902, "lng": -73.9705, "name": "Albert J. Parham Playground Public Restroom", "comment": "Between Adelphi St & Clermont Ave & between Willoughby Ave & Dekalb Ave"
    },
    { "lat": 40.6135, "lng": -74.0983, "name": "Terrace Playground Public Restroom", "comment": "Howard Avenue & Martha Street"
    },
    { "lat": 40.5724, "lng": -73.9885, "name": "West 22nd Street Public Restroom", "comment": "Riegelmann Boardwalk, near W. 22nd St."
    },
    { "lat": 40.697, "lng": -73.8964, "name": "Evergreen Park Public Restroom", "comment": "St Felix Ave. between Seneca Ave. and 60 Pl."
    },
    { "lat": 40.716, "lng": -73.9373, "name": "Carnegie Playground Public Restroom", "comment": "Sharon, Olive Streets, Maspeth & Morgan Avenues"
    },
    { "lat": 40.8356, "lng": -73.8997, "name": "Playground of the Stars Public Restroom", "comment": "173rd Street and Fulton Avenue"
    },
    { "lat": 40.8899, "lng": -73.8813, "name": "Allen Shandler Recreation Area Public Restroom", "comment": "Jerome Avenue and East 233rd Street"
    },
    { "lat": 40.7225, "lng": -73.8371, "name": "Willow Lake Playground Public Restroom", "comment": "Grand Central Parkway between 71 & 72 Avenues"
    },
    { "lat": 40.8202, "lng": -73.8263, "name": "Ferry Point Park East Public Restroom", "comment": "Balcom Avenue & Dewey Avenue"
    },
    { "lat": 40.7438, "lng": -73.8615, "name": "Josephine Caminiti Playground Public Restroom", "comment": "Alystine Avenue & 102 Street"
    },
    { "lat": 40.6079, "lng": -73.9374, "name": "Carmine Carro Community Center", "comment": "3000 Fillmore Ave"
    },
    { "lat": 40.6381, "lng": -73.9381, "name": "Paerdegat Park Public Restroom", "comment": "Foster Avenue, East 40-41 Streets"
    },
    { "lat": 40.6558, "lng": -73.8868, "name": "Ethan Allen Playground Public Restroom", "comment": "New Jersey Avenue & Vermont Street/Worthman"
    },
    { "lat": 40.6328, "lng": -73.9773, "name": "DiGilio Playground Public Restroom", "comment": "McDonald Avenue & Avenue F"
    },
    { "lat": 40.636, "lng": -73.8832, "name": "American Legion Liberty Post #1073", "comment": "American Legion Ballfields near E. 102nd St. & Seaview Ave."
    },
    { "lat": 40.7067, "lng": -73.7531, "name": "Hollis Playground Public Restroom", "comment": "205 Street & Hollis Avenue"
    },
    { "lat": 40.8005, "lng": -73.9239, "name": "Bronx Shore Fields Public Restroom", "comment": "Bronx Shore Road, Between Fields 3 & 4"
    },
    { "lat": 40.8214, "lng": -73.926, "name": "Franz Sigel Park Ballfields Public Restroom", "comment": "Grand Concourse at East 153rd Street"
    },
    { "lat": 40.6976, "lng": -73.9792, "name": "Commodore Barry Park Public Restroom", "comment": "South of Flushing Avenue"
    },
    { "lat": 40.7287, "lng": -73.9576, "name": "American Playground Public Restroom", "comment": "Franklin St between Noble St and Milton St"
    },
    { "lat": 40.6818, "lng": -73.9134, "name": "Marion Hopkinson Playground Public Restroom", "comment": "Hopkinson Avenue & Marion Street"
    },
    { "lat": 40.5875, "lng": -73.7957, "name": "Beach 67 Modular Public Restroom", "comment": "Boardwalk @ Beach 67 Street"
    },
    { "lat": 40.6083, "lng": -73.9865, "name": "Seth Low Playground/Bealin Square Public Restroom", "comment": "Avenue P, Bay Parkway, West 12 Street"
    },
    { "lat": 40.6859, "lng": -73.8531, "name": "London Planetree Playground Public Restroom", "comment": "95th Ave between 88th St & 89th St"
    },
    { "lat": 40.6622, "lng": -73.7422, "name": "Brookville Park Public Restroom", "comment": "Conduit Avenue, Brookville Boulevard, 144th Avenue, 233rd Street"
    },
    { "lat": 40.6433, "lng": -73.9232, "name": "Harry Maze Playground Public Restroom", "comment": "Avenue D between East 56 & East 57 Street"
    },
    { "lat": 40.7704, "lng": -73.8063, "name": "Bowne Park Field House", "comment": "159 Street, 29 Avenue, 155 Street, 32 Avenue"
    },
    { "lat": 40.733, "lng": -73.8715, "name": "Hoffman Park Public Restroom", "comment": "Hoffman Drive west of Queens Boulevard"
    },
    { "lat": 40.8375, "lng": -73.8538, "name": "Caserta Playground Public Restroom", "comment": "St. Raymond Avenue, Purdy Street"
    },
    { "lat": 40.6587, "lng": -73.9218, "name": "Kennedy King Playground Public Restroom", "comment": "East 93 Street & Lenox Road"
    },
    { "lat": 40.7262, "lng": -73.8479, "name": "Yellowstone Park Public Restroom", "comment": "Yellowstone Boulevard between 68 Avenue & 68 Road"
    },
    { "lat": 40.83, "lng": -73.8479, "name": "Havemeyer Playground Public Restroom", "comment": "Watson Avenue, Havemeyer Avenue, Cross Bronx Expressway"
    },
    { "lat": 40.6519, "lng": -73.9657, "name": "Stewart Playground Public Restroom", "comment": "Parade Pl. between Woodruff Ave. & Crooke Ave."
    },
    { "lat": 40.7219, "lng": -73.8239, "name": "Queens Valley Playground Public Restroom", "comment": "137 Street & 77 Avenue"
    },
    { "lat": 40.6437, "lng": -74.1088, "name": "Walker Park Tennis House", "comment": "Delafield Pl. & Bard Ave."
    },
    { "lat": 40.6393, "lng": -74.032, "name": "Owl's Head Park Public Restroom", "comment": "68th St between Narrows Ave & Bliss Terr"
    },
    { "lat": 40.6875, "lng": -73.8901, "name": "Highland Park Barbecue Area Public Restroom", "comment": "mid-Park near Vermont Place"
    },
    { "lat": 40.8312, "lng": -73.9247, "name": "Rev. T. Wendell Foster Skate Park Public Restroom", "comment": "East 164 Street near River Avenue"
    },
    { "lat": 40.7963, "lng": -73.8257, "name": "Francis Lewis Park Public Restroom", "comment": "3 Avenue and Bronx Whitestone Bridge"
    },
    { "lat": 40.6748, "lng": -73.9292, "name": "Woods Playground Public Restroom", "comment": "Bergen Street & Utica Avenue"
    },
    { "lat": 40.7975, "lng": -73.9353, "name": "P.S. 155 Playground Public Restroom", "comment": "East 117 to East 118 Streets, 1 to 2 Avenues"
    },
    { "lat": 40.8871, "lng": -73.9162, "name": "Spuyten Duyvil Playground Public Restroom", "comment": "Douglas Ave between West 235th St & West 236th St"
    },
    { "lat": 40.7014, "lng": -74.015, "name": "The View at Battery ", "comment": "Battery Park Underpass at South St."
    },
    { "lat": 40.7218, "lng": -73.974, "name": "East River Park Track Public Restroom", "comment": "Near East 6th Street Entrance"
    },
    { "lat": 40.6701, "lng": -73.8446, "name": "Vito Locascio Field Public Restroom", "comment": "North Conduit & 149 Avenue"
    },
    { "lat": 40.5924, "lng": -73.7626, "name": "Beach 30th Street Playground Public Restroom", "comment": "Boardwalk at Beach 32nd Street"
    },
    { "lat": 40.5748, "lng": -74.0984, "name": "Midland Playground Public Restroom", "comment": "Midland Avenue, South of Mason Avenue"
    },
    { "lat": 40.624, "lng": -73.9849, "name": "Gravesend Park Public Restroom", "comment": "18 Avenue & 56 Street"
    },
    { "lat": 40.5683, "lng": -74.0908, "name": "Midland Beach Playground Public Restroom", "comment": "Greeley Ave & Father Capodanno Blvd"
    },
    { "lat": 40.8472, "lng": -73.9462, "name": "Fort Washington Park Tennis Courts Public Restroom", "comment": "South of Little Red Lighthouse"
    },
    { "lat": 40.6557, "lng": -73.9475, "name": "Rolph Henry Playground Public Restroom", "comment": "New York & Clarkson Avenues"
    },
    { "lat": 40.5882, "lng": -73.8094, "name": "Hammel Playground Public Restroom", "comment": "B 83 Street & Rockaway Beach Boulevard"
    },
    { "lat": 40.7797, "lng": -73.9884, "name": "Riverside South – Pier I Café", "comment": "Riverside Drive bet.ween 65 St. and 72 St."
    },
    { "lat": 40.8726, "lng": -73.8829, "name": "Mosholu Playground Public Restroom", "comment": "Mosholu Pkwy, Bainbridge Avenue, Briggs Avenue"
    },
    { "lat": 40.673, "lng": -73.9846, "name": "Old Stone House of Brooklyn", "comment": "336 3rd St"
    },
    { "lat": 40.6877, "lng": -73.7725, "name": "Roy Wilkins Field House", "comment": "south of track, enter at Foch Blvd. & Merrick Blvd."
    },
    { "lat": 40.7364, "lng": -74.0056, "name": "Bleecker Playground Public Restroom", "comment": "Hudson & West 11 Streets"
    },
    { "lat": 40.8553, "lng": -73.9175, "name": "Cedar Playground Public Restroom", "comment": "Cedar Avenue, mid-park near W. 179th St."
    },
    { "lat": 40.74, "lng": -73.7342, "name": "Alley Athletic Playground Public Restroom", "comment": "Grand Central Parkway, Winchester Boulevard, & Union Turnpike"
    },
    { "lat": 40.7114, "lng": -73.7982, "name": "Captain Tilly Park Public Restroom", "comment": "Highland Avenue, Upland Parkway, Gothic Parkway, 85 Avenue"
    },
    { "lat": 40.8735, "lng": -73.8678, "name": "Magenta Playground Public Restroom", "comment": "Olinville Avenue, Rosewood Street"
    },
    { "lat": 40.745, "lng": -73.8173, "name": "Kissena Cricket Fields Public Restroom", "comment": "56th Avenue & 151st Street"
    },
    { "lat": 40.5174, "lng": -74.191, "name": "Wolfe's Pond Park - District 3 HQ", "comment": "At beachfront, south of parking lot"
    },
    { "lat": 40.8317, "lng": -73.9416, "name": "Wright Brothers Playground Public Restroom", "comment": "West 156 Street & St. Nicholas Avenue"
    },
    { "lat": 40.8259, "lng": -73.9413, "name": "Playground One Forty Nine CIL Public Restroom", "comment": "West 149 Street & Bradhurst Avenue"
    },
    { "lat": 40.6494, "lng": -74.0121, "name": "Pena Herrera Playground Public Restroom", "comment": "46 & 47 Streets, 3 Avenue"
    },
    { "lat": 40.8544, "lng": -73.8697, "name": "Ben Abrams Playground Public Restroom", "comment": "Lydig Avenue & Bronx Park East"
    },
    { "lat": 40.7358, "lng": -73.8054, "name": "Electric Playground Public Restroom", "comment": "164 Street, south of 65 Avenue"
    },
    { "lat": 40.8777, "lng": -73.9079, "name": "Marble Hill Playground Public Restroom", "comment": "Marble Hill Avenue, West 230 Street, West 228 Street"
    },
    { "lat": 40.7217, "lng": -73.758, "name": "Bellaire Playground Public Restroom", "comment": "89 Avenue, 207 & 208 Streets"
    },
    { "lat": 40.8156, "lng": -73.949, "name": "St Nicholas Playground at West 133rd St. Public Restroom", "comment": "St. Nicholas Avenue and W. 133rd Street"
    },
    { "lat": 40.8661, "lng": -73.8687, "name": "Zimmerman Playground Public Restroom", "comment": "Britton Street, Barker Avenue, Olinville Avenue"
    },
    { "lat": 40.6728, "lng": -74.0078, "name": "Red Hook Park Public Restroom", "comment": "Bay St. & Columbia St."
    },
    { "lat": 40.8089, "lng": -73.9193, "name": "Saw Mill Playground Public Restroom", "comment": "Brook Avenue between E. 139th St. & E. 140th St."
    },
    { "lat": 40.7158, "lng": -73.837, "name": "Ehrenreich-Austin Playground Public Restroom", "comment": "Austin Street between 76 Avenue & 76 Drive"
    },
    { "lat": 40.6608, "lng": -73.7623, "name": "Springfield Playground Public Restroom", "comment": "Near ballfields at 184th Street between 146 Rd & 146 Ter"
    },
    { "lat": 40.7837, "lng": -73.9262, "name": "Scylla Playground Public Restroom", "comment": "Wards Meadow Loop & Hell Gate Circle"
    },
    { "lat": 40.8095, "lng": -73.917, "name": "People's Park Public Restroom", "comment": "Brook Avenue, East 141 Street"
    },
    { "lat": 40.8876, "lng": -73.8588, "name": "Rienzi Playground Public Restroom", "comment": "East 226 Street, Barnes Avenue, East 225 Street"
    },
    { "lat": 40.583, "lng": -73.8176, "name": "Beach 97th Street Public Restroom", "comment": "Boardwalk at Beach 97th Street"
    },
    { "lat": 40.6963, "lng": -73.9976, "name": "Pierrepont Playground Public Restroom", "comment": "Furman Street, Pierrepont Place"
    },
    { "lat": 40.5982, "lng": -73.9396, "name": "Herman Dolgon Playground Public Restroom", "comment": "Avenue V & Nostrand Avenue"
    },
    { "lat": 40.6435, "lng": -74.0862, "name": "Mahoney Playground Public Restroom", "comment": "Beechwood & Cleveland Avenues"
    },
    { "lat": 40.5988, "lng": -73.7675, "name": "Bayswater Playground Public Restroom", "comment": "Beach Channel Drive, B 32 Street, Dwight Avenue, Norton Avenue"
    },
    { "lat": 40.7002, "lng": -73.7582, "name": "Daniel M. O'Connell Playground Public Restroom", "comment": "113 Avenue & 196 Street"
    },
    { "lat": 40.7563, "lng": -73.9997, "name": "Hudson Park Public Restroom", "comment": "W. 36th St. & Hudson Blvd. E."
    },
    { "lat": 40.8256, "lng": -73.9539, "name": "Riverbank Playground Public Restroom", "comment": "West 142 Street & Riverside Drive"
    },
    { "lat": 40.7829, "lng": -73.9446, "name": "Stanley Isaacs Playground Public Restroom", "comment": "East 96-97 Streets & FDR Drive"
    },
    { "lat": 40.6772, "lng": -74.0087, "name": "Coffey Park Public Restroom", "comment": "King, Richards, & Dwight Streets"
    },
    { "lat": 40.6123, "lng": -73.9112, "name": "Lindower Park Public Restroom", "comment": "Mill & Strickland Avenues, 60 Street"
    },
    { "lat": 40.8298, "lng": -73.9527, "name": "Ten Mile River Playground Public Restroom", "comment": "West 148 Street & Hudson River"
    },
    { "lat": 40.8152, "lng": -73.8986, "name": "Fox Park-Public Restroom", "comment": "Fox Street and East 156 Street"
    },
    { "lat": 40.8843, "lng": -73.867, "name": "Olinville Playground Public Restroom", "comment": "East 219 Street & Bronx River Parkway"
    },
    { "lat": 40.7716, "lng": -73.9347, "name": "Hallets Cove Playground (area A) Public Restroom", "comment": "Hallets Cove, Vernon Boulevard"
    },
    { "lat": 40.8235, "lng": -73.8505, "name": "P.O. Serrano Playground Public Restroom", "comment": "Turnbull Avenue, Olmstead Avenue, Lafayette Avenue"
    },
    { "lat": 40.7008, "lng": -73.9855, "name": "Bridge Park Public Restroom", "comment": "Jay Street, York Street, Bridge Street, Prospect Street"
    },
    { "lat": 40.7323, "lng": -73.7317, "name": "Detective William T. Gunn Playground Public Restroom", "comment": "Hillside Avenue, east of 235 Court"
    },
    { "lat": 40.8143, "lng": -73.8859, "name": "Hunts Point Playground Public Restroom", "comment": "Spofford Avenue, Hunts Point Avenue, Faile Street"
    },
    { "lat": 40.5978, "lng": -74.0712, "name": "Arrochar Playground Public Restroom", "comment": "228 Major Avenue"
    },
    { "lat": 40.6477, "lng": -74.005, "name": "Sunset Park Public Restroom", "comment": "44th St between 5th Ave & 6th Ave"
    },
    { "lat": 40.8154, "lng": -73.9014, "name": "Playground 52 LII Public Restroom", "comment": "Kelly Street, St. John's Avenue, Beck Street"
    },
    { "lat": 40.6186, "lng": -73.8988, "name": "McGuire Fields Public Restroom", "comment": "Ave Y., Bergen Ave. bet. Ave. V and Belt Pkwy."
    },
    { "lat": 40.7188, "lng": -73.993, "name": "Lions Gate Field Public Restroom", "comment": "Broome Street between Forsyth St. & Christie St."
    },
    { "lat": 40.8244, "lng": -73.9315, "name": "Mill Pond Park Power House Building", "comment": "Exterior Street & E. 153rd Street"
    },
    { "lat": 40.8248, "lng": -73.8943, "name": "Tiffany Playground Public Restroom", "comment": "Tiffany Street, Fox Street, East 167 Street"
    },
    { "lat": 40.7328, "lng": -73.7177, "name": "Bellerose Playground Public Restroom", "comment": "85 Avenue, 248 & 249 Streets"
    },
    { "lat": 40.6037, "lng": -73.9576, "name": "Kelly Park Playground Public Restroom", "comment": "Avenue S, East 14 & East 15 Streets"
    },
    { "lat": 40.6654, "lng": -73.886, "name": "Schenck Playground Public Restroom", "comment": "Livonia Ave. between Barbey St. and Schenck Ave."
    },
    { "lat": 40.7496, "lng": -73.8232, "name": "Silent Springs Playground PR", "comment": "45-20 Colden Street"
    },
    { "lat": 40.7311, "lng": -73.8517, "name": "Annadale Playground Public Restroom", "comment": "Yellowstone Boulevard, 65 Road, 65 Avenue"
    },
    { "lat": 40.684, "lng": -73.8858, "name": "Lower Highland Playground Public Restroom", "comment": "Jamaica Avenue & Elton Street"
    },
    { "lat": 40.7499, "lng": -73.7208, "name": "Castlewood Playground Public Restroom", "comment": "Little Neck Parkway & 72 Avenue"
    },
    { "lat": 40.6798, "lng": -73.9316, "name": "Fulton Park Public Restroom", "comment": "Fulton, Chauncey Streets, Stuyvesant, Lewis Avenues"
    },
    { "lat": 40.7099, "lng": -73.8354, "name": "Sobelsohn Playground Public Restroom", "comment": "Park Lane South and Abingdon Road"
    },
    { "lat": 40.6368, "lng": -74.0008, "name": "Rappaport Playground Public Restroom", "comment": "52-53 Streets, Fort Hamilton Parkway"
    },
    { "lat": 40.8559, "lng": -73.8866, "name": "Ciccarone Park Public Restroom", "comment": "Arthur Avenue, East 188 Street"
    },
    { "lat": 40.8173, "lng": -73.939, "name": "Fred Samuel Playground Public Restroom", "comment": "Lenox Avenue, West 139 to West 140 Streets"
    },
    { "lat": 40.6492, "lng": -73.8738, "name": "Spring Creek Park-Public Restroom ", "comment": ""
    },
    { "lat": 40.8816, "lng": -73.8959, "name": "Fort Independence Playground Public Restroom", "comment": "Stevenson Place, West 238 Street, Sedgwick Avenue"
    },
    { "lat": 40.678, "lng": -73.7867, "name": "121st Avenue Entrance Public Restroom", "comment": "121st Ave. & 155th St."
    },
    { "lat": 40.5785, "lng": -73.9954, "name": "Kaiser Park Public Restroom", "comment": "South of Gravesend Bay, southeast of Path, northeast of Neptune Avenue"
    },
    { "lat": 40.835, "lng": -73.9266, "name": "Nelson Playground Public Restroom", "comment": "West 166 Street, Nelson Avenue, Woodycrest Avenue"
    },
    { "lat": 40.6926, "lng": -73.9622, "name": "Pratt Playground Public Restroom", "comment": "Willoughby Avenue, Emerson Place"
    },
    { "lat": 40.9018, "lng": -73.8548, "name": "Wakefield Playground Public Restroom", "comment": "Matilda Avenue, East 239 Street, Carpenter Avenue"
    },
    { "lat": 40.5728, "lng": -73.9808, "name": "Stillwell Ave. Public Restroom", "comment": "Boardwalk between W. 10th St. & Stillwell Ave."
    },
    { "lat": 40.839, "lng": -73.8662, "name": "Taylor Playground Public Restroom", "comment": "Guerlain Street, Thieriot Avenue, Taylor Avenue"
    },
    { "lat": 40.7804, "lng": -73.9691, "name": "Delacorte Theater Women's Restroom", "comment": "Mid-Park at 80th Street on the southwest corner of the Great Lawn"
    },
    { "lat": 40.8123, "lng": -73.9371, "name": "Abraham Lincoln Playground Public Restroom", "comment": "East 135 Street, between Madison & 5 Avenues"
    },
    { "lat": 40.6327, "lng": -73.9239, "name": "Fox Playground Public Restroom", "comment": "Avenue H, East 54 to E 55 Streets"
    },
    { "lat": 40.6145, "lng": -74.0294, "name": "John J Carty Park Public Restroom", "comment": "Fort Hamilton Parkway, 94-95 Streets"
    },
    { "lat": 40.6384, "lng": -73.9475, "name": "Nostrand Playground Public Restroom", "comment": "Nostrand & Foster Avenues"
    },
    { "lat": 40.674, "lng": -73.7564, "name": "Montbellier Park Public Restroom", "comment": "Springfield Boulevard & 139 Avenue"
    },
    { "lat": 40.6885, "lng": -73.7425, "name": "Cambria Playground Public Restroom", "comment": "121 Avenue & 220 Street"
    },
    { "lat": 40.7701, "lng": -73.827, "name": "Colden Playground Public Restroom", "comment": "Union Street & 31 Road"
    },
    { "lat": 40.7449, "lng": -73.9733, "name": "St. Vartan Park Public Restroom", "comment": "East 35-East 36 Streets, between 1 & 2 Avenues"
    },
    { "lat": 40.7967, "lng": -73.9752, "name": "Dinosaur Playground Public Restroom", "comment": "97th Street & Riverside Drive"
    },
    { "lat": 40.8506, "lng": -73.8875, "name": "Belmont Playground Public Restroom", "comment": "E. 182nd Street & Grote Street"
    },
    { "lat": 40.6744, "lng": -73.8651, "name": "Robert E. Venable Park Public Restroom", "comment": "Belmont Ave. & Sheridan Ave."
    },
    { "lat": 40.577, "lng": -73.9462, "name": "Pat Parlato Playground Public Restroom", "comment": "Ocean Ave. & Oriental Blvd."
    },
    { "lat": 40.7265, "lng": -73.7737, "name": "Upper Picnic Area Public Restroom", "comment": "North of Grand Central Parkway to ballfields & tennis courts between 193rd Street and Francis Lewis*"
    },
    { "lat": 40.8229, "lng": -73.9139, "name": "Yolanda García Park Public Restroom", "comment": "Melrose Ave. & E. 159th St."
    },
    { "lat": 40.7025, "lng": -73.9495, "name": "De Hostos Playground Public Restroom", "comment": "Harrison Ave between Lorimer St & Walton St"
    },
    { "lat": 40.7735, "lng": -73.9711, "name": "Bethesda Terrace", "comment": "Mid-Park at 72nd Street"
    },
    { "lat": 40.8883, "lng": -73.8981, "name": "Van Cortlandt Stadium", "comment": "Broadway between West 240 and West 242 Streets"
    },
    { "lat": 40.839, "lng": -73.853, "name": "Castle Hill Playground Public Restroom", "comment": "Parker Street, Castle Hill Avenue, Puroy Street"
    },
    { "lat": 40.8313, "lng": -73.9147, "name": "Mott Playground Public Restroom", "comment": "Morris Avenue, College Avenue, Mc Clellan Street"
    },
    { "lat": 40.7109, "lng": -73.9935, "name": "Coleman Playground Public Restroom", "comment": "Between Cherry & Monroe Streets"
    },
    { "lat": 40.8292, "lng": -73.9362, "name": "Holcombe Rucker Park Public Restroom", "comment": "West 155 Street, 8 Avenue to Harlem River Drive"
    },
    { "lat": 40.5889, "lng": -74.0668, "name": "Playland Playground Public Restroom", "comment": "Sand Lane & Father Capodanno Blvd"
    },
    { "lat": 40.7588, "lng": -73.754, "name": "Horatio Playground Public Restroom", "comment": "Horatio Parkway and 50 Avenue"
    },
    { "lat": 40.7929, "lng": -73.9247, "name": "Icahn Stadium", "comment": "Central Road"
    },
    { "lat": 40.7904, "lng": -73.782, "name": "Little Bay Park - Public Restroom", "comment": "211-01 Cross Island Parkway"
    },
    { "lat": 40.6659, "lng": -73.9589, "name": "Jackie Robinson Playground Public Restroom", "comment": "Sullivan Place & Franklin Avenue, Montgomery Street"
    },
    { "lat": 40.7061, "lng": -73.9624, "name": "Roebling Playground Public Restroom", "comment": "Wilson & Lee Avenues, Taylor Street"
    },
    { "lat": 40.8179, "lng": -73.9068, "name": "Captain Rivera Playground Public Restroom", "comment": "East 156 Street, Forest Avenue"
    },
    { "lat": 40.7715, "lng": -73.9887, "name": "Gertrude Ederle Recreation Center & Playground PR", "comment": "232 West 60th Street"
    },
    { "lat": 40.7504, "lng": -73.9875, "name": "Herald Square Public Restroom", "comment": "Ave. of the Americas & W. 35th St."
    },
    { "lat": 40.6804, "lng": -73.9205, "name": "Carver Playground Public Restroom", "comment": "Ralph Avenue & Sumpter Street"
    },
    { "lat": 40.7248, "lng": -73.9435, "name": "Monsignor McGolrick Playground Public Restroom", "comment": "Nashua Ave. between Monitor St. & Russell St."
    },
    { "lat": 40.6638, "lng": -73.7595, "name": "Springfield Park North Public Restroom", "comment": "145th Rd. & Springfield Blvd."
    },
    { "lat": 40.8153, "lng": -73.956, "name": "Sheltering Arms Playground Public Restroom", "comment": "West 129 Street, Amsterdam Avenue"
    },
    { "lat": 40.7007, "lng": -73.946, "name": "Bartlett Playground Public Restroom", "comment": "Bartlett Street & Throop Avenue"
    },
    { "lat": 40.585, "lng": -73.825, "name": "Bayside Playground-Public Restroom", "comment": "Beach Channel Drive @ Seaside Avenue"
    },
    { "lat": 40.747, "lng": -73.7456, "name": "Alley Park Public Restroom", "comment": "67 Avenue & 230 Street"
    },
    { "lat": 40.6864, "lng": -73.9658, "name": "Greene Playground Public Restroom", "comment": "Greene & Washington Avenues"
    },
    { "lat": 40.8735, "lng": -73.8393, "name": "Haffen Park Public Restroom", "comment": "Burke Avenue, Hammersley Avenue, Gunther Avenue, Ely Avenue"
    },
    { "lat": 40.5913, "lng": -73.9811, "name": "Marlboro Playground Public Restroom", "comment": "West 11 Street & Avenue W"
    },
    { "lat": 40.688, "lng": -73.9112, "name": "Tiger Playground Public Restroom", "comment": "Evergreen Avenue & Eldert Street"
    },
    { "lat": 40.7187, "lng": -73.8204, "name": "Judge Moses Weinstein Playground Public Restroom", "comment": "Vleigh Place & 141 Street"
    },
    { "lat": 40.7934, "lng": -73.978, "name": "Hippo Playground Public Restroom", "comment": "91st Street near Riverside Drive"
    },
    { "lat": 40.756, "lng": -73.8261, "name": "Maple Playground Public Restroom", "comment": "Kissena Boulevard & Maple Avenue"
    },
    { "lat": 40.8528, "lng": -73.9272, "name": "Wallenberg Playground Public Restroom", "comment": "W. 189th St. & Amsterdam Ave."
    },
    { "lat": 40.6802, "lng": -73.8024, "name": "Dr. Charles R. Drew Park Public Restroom", "comment": "Van Wyck Expressway, 116 Avenue, 140 Street, 115 Avenue"
    },
    { "lat": 40.7475, "lng": -73.9106, "name": "Lawrence Virgilio Playground Public Restroom", "comment": "39 Drive & 54 Street"
    },
    { "lat": 40.706, "lng": -73.8913, "name": "Mafera Park Public Restroom", "comment": "65 Place & Catalpa Avenue & 68 Avenue"
    },
    { "lat": 40.7332, "lng": -73.8603, "name": "Horace Harding Playground Public Restroom", "comment": "62 Drive between 97 Place & 98 Street"
    },
    { "lat": 40.72, "lng": -73.9815, "name": "Hamilton Fish Recreation Center", "comment": "128 Pitt St"
    },
    { "lat": 40.7042563, "lng": -73.9886841, "name": "Adams Street Library", "accessibility": "full", "comment": "9 Adams Street (between John and Plymouth) Brooklyn, NY 11201" },
    { "lat": 40.6806308, "lng": -73.8872311, "name": "Arlington Library", "accessibility": "full", "comment": "203 Arlington Ave. at Warwick St. Brooklyn, NY 11207" },
    { "lat": 40.6336184, "lng": -74.0295114, "name": "Bay Ridge Library", "accessibility": "full", "comment": "7223 Ridge Blvd. at 73rd St. Brooklyn, NY 11209" },
    { "lat": 40.681831, "lng": -73.9560213, "name": "Bedford Library", "accessibility": "full", "comment": "496 Franklin Avenue Brooklyn, NY 11238" },
    { "lat": 40.681831, "lng": -73.9560213, "name": "Bedford Library Learning Center", "accessibility": "partial", "comment": "496 Franklin Avenue Brooklyn, NY 11238" },
    { "lat": 40.6388137, "lng": -73.9891201, "name": "Borough Park Library", "accessibility": "full", "comment": "1265 43rd St. at 13th Ave. Brooklyn, NY 11219" },
    { "lat": 40.576069, "lng": -73.9667601, "name": "Brighton Beach Library", "accessibility": "full", "comment": "6 Brighton First Rd. at Brighton Beach Ave. Brooklyn, NY 11235" },
    { "lat": 40.6961204, "lng": -73.9914203, "name": "Brooklyn Heights Library", "accessibility": "full", "comment": "286 Cadman Plaza West Brooklyn, NY 11201" },
    { "lat": 40.6744268, "lng": -73.9439205, "name": "Brower Park Library at Brooklyn Children's Museum", "accessibility": "full", "comment": "145 Brooklyn Ave Brooklyn, NY 11213" },
    { "lat": 40.6708734, "lng": -73.9079603, "name": "Brownsville Library", "accessibility": "full", "comment": "61 Glenmore Ave. at Watkins St. Brooklyn, NY 11212" },
    { "lat": 40.7045728, "lng": -73.9395457, "name": "Bushwick Library", "accessibility": "full", "comment": "340 Bushwick Avenue Brooklyn, NY 11206" },
    { "lat": 40.6422625, "lng": -73.8994432, "name": "Canarsie Library", "accessibility": "partial", "comment": "1580 Rockaway Pkwy. at Ave. J Brooklyn, NY 11236" },
    { "lat": 40.6832331, "lng": -73.9980304, "name": "Carroll Gardens Library", "accessibility": "full", "comment": "396 Clinton St. Brooklyn, NY 11231" },
    { "lat": 40.6948029, "lng": -73.9924046, "name": "Center for Brooklyn History", "accessibility": "full", "comment": "128 Pierrepont Street Brooklyn, NY 11201" },
    { "lat": 40.6723862, "lng": -73.9682475, "name": "Central Library", "accessibility": "full", "comment": "10 Grand Army Plaza Brooklyn, NY 11238" },
    { "lat": 40.6723862, "lng": -73.9682475, "name": "Central Library Learning Center", "accessibility": "partial", "comment": "10 Grand Army Plaza Brooklyn, NY 11238" },
    { "lat": 40.6356657, "lng": -73.9476862, "name": "Clarendon Library", "accessibility": "full", "comment": "2035 Nostrand Ave. Brooklyn, NY 11210" },
    { "lat": 40.687401, "lng": -73.965943, "name": "Clinton Hill Library", "accessibility": "full", "comment": "380 Washington Ave. at Lafayette Ave. Brooklyn, NY 11238" },
    { "lat": 40.5767211, "lng": -73.9860632, "name": "Coney Island Library", "accessibility": "full", "comment": "1901 Mermaid Ave. (Near W. 19th St.) Brooklyn, NY 11224" },
    { "lat": 40.6406079, "lng": -73.9660055, "name": "Cortelyou Library", "accessibility": "full", "comment": "1305 Cortelyou Rd. at Argyle Rd. Brooklyn, NY 11226" },
    { "lat": 40.6612125, "lng": -73.9479385, "name": "Crown Heights Library", "accessibility": "full", "comment": "560 New York Ave. at Maple St. Brooklyn, NY 11225" },
    { "lat": 40.6726682, "lng": -73.8740205, "name": "Cypress Hills Library", "accessibility": "full", "comment": "1197 Sutter Ave. at Crystal St. Brooklyn, NY 11208" },
    { "lat": 40.6937519, "lng": -73.9296067, "name": "DeKalb Library", "accessibility": "partial", "comment": "790 Bushwick Ave. at DeKalb Ave. Brooklyn, NY 11221" },
    { "lat": 40.6163466, "lng": -74.0120111, "name": "Dyker Library", "accessibility": "full", "comment": "8202 13th Ave. (@ 82nd St.) Brooklyn, NY 11228" },
    { "lat": 40.6557119, "lng": -73.9149405, "name": "East Flatbush Library", "accessibility": "full", "comment": "9612 Church Ave Brooklyn, NY 11212" },
    { "lat": 40.6685507, "lng": -73.9336564, "name": "Eastern Parkway Learning Center", "accessibility": "full", "comment": "1044 Eastern Parkway - 2nd Floor Brooklyn, NY 11213" },
    { "lat": 40.6685507, "lng": -73.9336564, "name": "Eastern Parkway Library", "accessibility": "full", "comment": "1044 Eastern Pkwy. at Schenectady Ave. Brooklyn, NY 11213" },
    { "lat": 40.6519737, "lng": -73.9582372, "name": "Flatbush Learning Center", "accessibility": "partial", "comment": "22 Linden Blvd. at Flatbush Ave. Brooklyn, NY 11226" },
    { "lat": 40.6519737, "lng": -73.9582372, "name": "Flatbush Library", "accessibility": "full", "comment": "22 Linden Blvd. at Flatbush Ave. Brooklyn, NY 11226" },
    { "lat": 40.6196604, "lng": -73.9333236, "name": "Flatlands Library", "accessibility": "full", "comment": "2065 Flatbush Ave. at Ave. P Brooklyn, NY 11234" },
    { "lat": 40.6163589, "lng": -74.0313628, "name": "Fort Hamilton Library", "accessibility": "full", "comment": "9424 Fourth Ave. Brooklyn, NY 11209" },
    { "lat": 40.5914716, "lng": -73.9238771, "name": "Gerritsen Beach Library", "accessibility": "full", "comment": "2808 Gerritsen Ave. Brooklyn, NY 11229" },
    { "lat": 40.6269908, "lng": -73.9750264, "name": "Gravesend Library", "accessibility": "full", "comment": "303 Ave. X at West. 2nd St. Brooklyn, NY 11223" },
    { "lat": 40.7241392, "lng": -73.9502164, "name": "Greenpoint Library", "accessibility": "full", "comment": "107 Norman Ave. at Leonard St. Brooklyn, NY 11222" },
    { "lat": 40.6056946, "lng": -73.9862442, "name": "Highlawn Library", "accessibility": "full", "comment": "1664 W. 13th St. Brooklyn, NY 11223" },
    { "lat": 40.5952068, "lng": -73.9605023, "name": "Homecrest Library", "accessibility": "full", "comment": "2525 Coney Island Ave. at Ave. V Brooklyn, NY 11223" },
    { "lat": 40.6344803, "lng": -73.8893197, "name": "Jamaica Bay Library", "accessibility": "full", "comment": "9727 Seaview Ave. at E. 98th St. near Rockaway Pkwy. Brooklyn, NY 11236" },
    { "lat": 40.6313515, "lng": -73.9755116, "name": "Kensington Library", "accessibility": "full", "comment": "4207 18th Avenue Brooklyn, NY 11218" },
    { "lat": 40.5948765, "lng": -73.9411772, "name": "Kings Bay Library", "accessibility": "full", "comment": "3650 Nostrand Ave. (near Ave. W) Brooklyn, NY 11229" },
    { "lat": 40.6102804, "lng": -73.9532511, "name": "Kings Highway Library", "accessibility": "full", "comment": "2115 Ocean Ave. Brooklyn, NY 11229" },
    { "lat": 40.7114472, "lng": -73.9474944, "name": "Leonard Library", "accessibility": "partial", "comment": "81 Devoe St. at Leonard St. Brooklyn, NY 11211" },
    { "lat": 40.6829969, "lng": -73.9348732, "name": "Macon Library", "accessibility": "full", "comment": "361 Lewis Ave. at Macon St. Brooklyn, NY 11233" },
    { "lat": 40.6231593, "lng": -73.9894561, "name": "Mapleton Library", "accessibility": "full", "comment": "1702 60th Street Brooklyn, NY 11204" },
    { "lat": 40.680755, "lng": -73.9494015, "name": "Marcy Library", "accessibility": "full", "comment": "617 DeKalb Ave. at Nostrand Ave. Brooklyn, NY 11216" },
    { "lat": 40.6292287, "lng": -74.0118955, "name": "McKinley Park Library", "accessibility": "full", "comment": "6802 Fort Hamilton Pkwy (at 68th St.) Brooklyn, NY 11219" },
    { "lat": 40.625907, "lng": -73.9604005, "name": "Midwood Library", "accessibility": "full", "comment": "975 East 16th St. at Avenue J Brooklyn, NY 11230" },
    { "lat": 40.6198638, "lng": -73.9170083, "name": "Mill Basin Library", "accessibility": "full", "comment": "2385 Ralph Ave (near Ave N) Brooklyn, NY 11234" },
    { "lat": 40.6659975, "lng": -73.8855675, "name": "New Lots Learning Center", "accessibility": "full", "comment": "665 New Lots Avenue at Barbey St. Brooklyn, NY 11207" },
    { "lat": 40.6659975, "lng": -73.8855675, "name": "New Lots Library", "accessibility": "full", "comment": "665 New Lots Avenue at Barbey St. Brooklyn, NY 11207" },
    { "lat": 40.5850653, "lng": -73.9510009, "name": "New Utrecht Library", "accessibility": "full", "comment": "1743 86th St. at Bay 17th St. Brooklyn, NY 11214" },
    { "lat": 40.6521423, "lng": -73.9778355, "name": "Pacific Library", "accessibility": "partial", "comment": "25 Fourth Ave. at Pacific St. Brooklyn, NY 11217" },
    { "lat": 40.6326274, "lng": -73.9199457, "name": "Paerdegat Library", "accessibility": "full", "comment": "850 E. 59th St. at Paerdegat Ave. South Brooklyn, NY 11234" },
    { "lat": 40.6682239, "lng": -73.9834488, "name": "Park Slope Library", "accessibility": "full", "comment": "431 6th Ave Brooklyn, NY 11215" },
    { "lat": 40.675242, "lng": -74.0103423, "name": "Red Hook Library", "accessibility": "full", "comment": "7 Wolcott St Brooklyn, NY 11231" },
    { "lat": 40.6486123, "lng": -73.9303999, "name": "Rugby Library", "accessibility": "full", "comment": "1000 Utica Ave. Brooklyn, NY 11203" },
    { "lat": 40.6159104, "lng": -73.9759322, "name": "Ryder Library", "accessibility": "full", "comment": "5902 23rd Ave. Brooklyn, NY 11204" },
    { "lat": 40.6848144, "lng": -73.9152118, "name": "Saratoga Library", "accessibility": "full", "comment": "8 Thomas S. Boyland St. at Macon St. Brooklyn, NY 11233" },
    { "lat": 40.586996, "lng": -73.9553979, "name": "Sheepshead Bay Library", "accessibility": "full", "comment": "2636 E. 14th St. at Ave. Z Brooklyn, NY 11235" },
    { "lat": 40.6532694, "lng": -73.8857767, "name": "Spring Creek Library", "accessibility": "full", "comment": "12143 Flatlands Ave. at New Jersey Ave. Brooklyn, NY 11207" },
    { "lat": 40.6645452, "lng": -73.9053547, "name": "Stone Avenue Library", "accessibility": "full", "comment": "581 Mother Gaston Boulevard Brooklyn, NY 11212" },
    { "lat": 40.6504822, "lng": -74.0078969, "name": "Sunset Park Library", "accessibility": "partial", "comment": "4201 Fourth Avenue Brooklyn, NY 11232" },
    { "lat": 40.5985344, "lng": -73.9976377, "name": "Ulmer Park Library", "accessibility": "full", "comment": "2602 Bath Avenue at 26th Ave Brooklyn, NY 11214" },
    { "lat": 40.6944732, "lng": -73.9778261, "name": "Walt Whitman Library", "accessibility": "full", "comment": "93 Saint Edwards Street Brooklyn, NY 11205" },
    { "lat": 40.6974978, "lng": -73.9122161, "name": "Washington Irving Library", "accessibility": "full", "comment": "360 Irving Ave. (at Woodbine St.) Brooklyn, NY 11237" },
    { "lat": 40.7069891, "lng": -73.9575624, "name": "Williamsburgh Library", "accessibility": "full", "comment": "240 Division Ave. at Marcy Ave. Brooklyn, NY 11211" },
    { "lat": 40.6486979, "lng": -73.9767751, "name": "Windsor Terrace Library", "accessibility": "partial", "comment": "160 E. 5th St. at Ft. Hamilton Pkwy. Brooklyn, NY 11218" }]
    """
}
