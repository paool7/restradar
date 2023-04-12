//
//  BathroomView.swift
//  G2G
//
//  Created by Paul Dippold on 3/19/23.
//

import SwiftUI
import MapKit

struct BathroomView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @Binding var bathroom: Bathroom
        
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HeaderView(bathroom: $bathroom,moreDetail: true)
                .padding(16)
            DirectionsView(bathroom: $bathroom, id: bathroom.id)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()

                Button {
                    if let index = bathroomAttendant.favoriteBathrooms.firstIndex(where: { $0.id == bathroom.id }) {
                        bathroomAttendant.favoriteBathrooms.remove(at: index)
                    } else {
                        bathroomAttendant.favoriteBathrooms.append(bathroom)
                    }
                } label: {
                    Image(systemName: bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id })  ? "bookmark.fill" : "bookmark")
                        .foregroundColor(bathroomAttendant.favoriteBathrooms.contains(where: { $0.id == bathroom.id }) ? .yellow : .primary)
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
