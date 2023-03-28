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
    @State var id: Int
    
    @State private var contentSize: CGSize = .zero

    var body: some View {
        if let bathroom = $attendant.defaults.first(where: {$0.id == self.id}) {
            VStack(alignment: .leading, spacing: 8) {
                HeaderView(id: bathroom.id)
                if let directions = bathroom.directions {
                    ScrollView {
                        ForEach(directions, id: \.self) { $direction in
                            HStack {
                                Text(Image(systemName: direction == directions.first?.wrappedValue ? "figure.wave" : (direction == directions.last?.wrappedValue ? "figure.stand" : "figure.walk")))
                                Text(direction)
                                Spacer()
                            }
                        }
                        .padding(8)
                    }
                    .frame(maxWidth: .infinity)
                    .background {
                        Color(uiColor: .secondarySystemBackground)
                            .cornerRadius(16)
                    }
                }
                Spacer()
            }
            .padding(16)
            .onAppear {
                if bathroom.wrappedValue.directions.isEmpty {
                    LocationAttendant.shared.getDirections(to: self.id)
                }
            }
        }
    }
}

struct BathroomView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomView(id: 2)
    }
}
