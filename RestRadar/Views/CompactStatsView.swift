//
//  CompactStatsView.swift
//  G2G
//
//  Created by Paul Dippold on 4/15/23.
//

import SwiftUI

struct CompactStatsView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @StateObject var bathroom: Bathroom
    
    var body: some View {
            HStack {
                if let current = locationAttendant.current {
                    HStack(alignment: .center) {
                        Text("\(bathroom.totalTime() ?? 0)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Image(systemName: "hourglass")
                            .font(.subheadline)
                    }.frame(maxWidth: .infinity)
                        .fixedSize(horizontal: true, vertical: false)
                    Divider()
                        .overlay(.primary)
                }
                if bathroom.totalBlocks > 0 {
                    HStack(alignment:.center) {
                        Text("\(bathroom.totalBlocks)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Image(systemName: "building.2")
                            .font(.subheadline)
                    }.frame(maxWidth: .infinity)
                    .fixedSize(horizontal: true, vertical: false)
                    
                    Divider()
                        .overlay(.primary)
                } else if let current = locationAttendant.current, let stepsAway = bathroom.totalSteps() {
                    HStack(alignment:.center) {
                        Text("\(stepsAway)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Image(systemName: "figure.walk.motion")
                            .font(.subheadline)
                    }.frame(maxWidth: .infinity)
                    .fixedSize(horizontal: true, vertical: false)
                    
                    Divider()
                        .overlay(.primary)
                }
                
                HStack(alignment: .center) {
                    Image(systemName: bathroom.code != nil ? "lock" : "lock.open")
                        .font(.subheadline)
                        .bold()
                    if let code = bathroom.code {
                        Text(code)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }.frame(maxWidth: .infinity)
                .fixedSize(horizontal: true, vertical: false)
                
                if bathroom.address != nil {
                    Divider()
                        .overlay(.primary)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "exclamationmark.bubble")
                            .font(.subheadline)
                            .bold()
                    }.frame(maxWidth: .infinity)
                    .fixedSize(horizontal: true, vertical: false)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
    }
}

struct CompactStatsView_Previews: PreviewProvider {
    static var previews: some View {
        CompactStatsView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}
