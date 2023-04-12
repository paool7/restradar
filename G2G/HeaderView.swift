//
//  HeaderView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import SwiftUI
import MapKit

struct HeaderView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @Binding var bathroom: Bathroom
    
    @State var moreDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(bathroom.name)
                    .font(.title)
                    .bold()
                if moreDetail {
                    HStack {
                        Image(systemName: "mappin")
                        Text(bathroom.address)
                            .font(.callout)
                    }
                }
                if let code = bathroom.code {
                    HStack {
                        Image(systemName: "lock.shield")
                        Text("Code: \(code)")
                            .font(.callout)
                    }
                }
                if let comment = bathroom.comment {
                    HStack{
                        Image(systemName: "exclamationmark.bubble")
                        Text(comment)
                            .font(.callout)
                    }
                }
            }
            CompassView(bathroom: $bathroom)
                .aspectRatio(contentMode: .fill)
            if let current = locationAttendant.current, let instruction = bathroom.currentRouteStep(current: current)?.naturalCurrentInstruction(current: current) {
                Text(instruction)
                    .font(.headline)
            } else if let firstStepInstructions = bathroom.route?.steps.first?.naturalInstructions {
                Text(firstStepInstructions)
                    .font(.headline)
            }
        }
        .padding(8)
        .foregroundColor(.primary)
        .frame(maxHeight: .infinity)
        .onAppear {
            if bathroom.directions.isEmpty {
                locationAttendant.getDirections(to: bathroom.id)
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(bathroom: .constant(BathroomAttendant().closestBathroom), moreDetail: true)
    }
}
