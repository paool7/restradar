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
    @State var id: Int

    let height = 275.0
    
    var body: some View {
        if let bathroom = $attendant.defaults.first(where: {$0.id == self.id}) {
            VStack(alignment: .center, spacing: 8) {
                Text(bathroom.name.wrappedValue)
                    .font(.title2)
                    .bold()
                BadgeSymbol()
                    .scaledToFit()
                    .frame(height: height)
                    .rotationEffect(.degrees(bathroom.heading.wrappedValue))
                    .opacity(0.75)
                    .overlay {
                        ZStack {
                            MapView(id: bathroom.id)
                                .clipShape(Circle())
                                .padding(height * 0.16)
                            if let direction = bathroom.directions.first?.wrappedValue {
                                CircleLabelView(text: direction, radius: 275/2, clockwise: true)
                                    .font(.system(size: 13, design: .monospaced)).bold()
                                    .kerning(2.0)
                                    .foregroundColor(.white)
                                    .padding(26)
                                    .rotationEffect(.degrees(bathroom.heading.wrappedValue))
                            }
                            if let distanceAway = bathroom.distanceAway.wrappedValue {
                                CircleLabelView(text: distanceAway, radius: 275/2, clockwise: false)
                                    .font(.system(size: 13, design: .monospaced)).bold()
                                    .kerning(2.0)
                                    .foregroundColor(.white)
                                    .padding(26)
                                    .rotationEffect(.degrees(bathroom.heading.wrappedValue))
                            }
                        }
                    }
                
                if let code = bathroom.code.wrappedValue {
                    HStack {
                        Image(systemName: "lock.shield")
                        Text("Code: \(code)")
                            .font(.callout)
                    }
                }
                if let comment = bathroom.comment.wrappedValue {
                    HStack{
                        Image(systemName: "exclamationmark.bubble")
                        Text(comment)
                            .font(.callout)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background {
                Color(uiColor: .secondarySystemBackground)
            }
            .cornerRadius(16)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(id: 2)
    }
}
