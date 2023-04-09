//
//  HeaderView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import SwiftUI
import MapKit

struct HeaderView: View {
    @ObservedObject var attendant = BathroomAttendant.shared
    @Binding var bathroom: Bathroom
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            VStack(alignment: .center, spacing: 2) {
                Text(bathroom.name)
                    .font(.title)
                    .bold()
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
                .frame(maxWidth: .infinity)
            if let instruction = bathroom.currentRouteStep?.naturalCurrentInstruction {
                Text(instruction)
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background {
            Color(uiColor: .secondarySystemBackground)
        }
        .cornerRadius(16)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(bathroom: .constant(BathroomAttendant.shared.closestBathroom))
    }
}
