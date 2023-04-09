//
//  BathroomCellView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI

struct BathroomCellView: View {
    @Binding var bathroom: Bathroom
    
    var body: some View {
        NavigationLink(destination: BathroomView(bathroom: $bathroom)) {
            VStack(alignment: .leading, spacing: 2) {
                HStack{
                    Text(bathroom.name)
                        .font(.headline)
                    Image(systemName: "arrow.up.circle")
                        .rotationEffect(.degrees(bathroom.generalHeading))
                    Spacer()
                    if bathroom.isFavorited {
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(.yellow)
                    }
                }
                if let distanceAway = bathroom.distanceAway, let timeAway = bathroom.timeAway {
                    HStack {
                        Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
                        Text("\(timeAway) • \(distanceAway)")
                            .font(.callout)
                    }
                }
                if let code = bathroom.code {
                    HStack{
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
        }    }
}

struct BathroomCellView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomCellView(bathroom: .constant(BathroomAttendant.shared.closestBathroom))
    }
}
