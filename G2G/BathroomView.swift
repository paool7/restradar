//
//  BathroomView.swift
//  G2G
//
//  Created by Paul Dippold on 3/19/23.
//

import SwiftUI
import MapKit

struct BathroomView: View {
    @ObservedObject var attendant = BathroomAttendant.shared
    @ObservedObject var locAttendant = LocationAttendant.shared
    @Binding var bathroom: Bathroom
        
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HeaderView(bathroom: $bathroom)
            DirectionsView(directions: $bathroom.directions, id: bathroom.id)
        }
        .padding(16)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Image(systemName: "bookmark")
                    
                }

                Spacer()

                Button("Second") {
                    print("Pressed")
                }
            }
        }
    }
}

struct BathroomView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomView(bathroom: .constant(BathroomAttendant.shared.closestBathroom))
    }
}
