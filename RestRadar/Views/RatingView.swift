//
//  RatingView.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Karte
import MapKit
import MessageUI
import SafariServices
import Shiny
import SwiftUI
import TelemetryClient

enum RatingType: String, Identifiable, CaseIterable, Codable {
    case clean
    case accessible

    var id: String { rawValue }
    
    var image: String {
        switch self {
        case .clean:
            return "bubbles.and.sparkles"
        case .accessible:
            return "figure.roll"
        }
    }
}

enum Rating: String, Identifiable, CaseIterable, Codable {
    case upvote = "Yes"
    case downvote = "No"
    case unknown = "Unknown"
    
    var id: String { rawValue }
    
    var image: String {
        switch self {
        case .upvote:
            return "hand.thumbsup"
        case .downvote:
            return "hand.thumbsdown"
        case .unknown:
            return "questionmark"
        }
    }
    
    var boolValue: Bool? {
        switch self {
        case .upvote:
            return true
        case .downvote:
            return false
        case .unknown:
            return nil
        }
    }
}

struct RatingView: View {
    @StateObject var bathroom: Bathroom
    
    @Binding var rating: Rating
    var ratingType: RatingType = .clean

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack(spacing: -8) {
                Picker(selection: $rating, label: Text("\(ratingType.rawValue)?")) {
                    ForEach(Rating.allCases) { rating in
                        Label("", systemImage: rating.image).tag(rating as Rating)
                    }
                }
                Image(systemName: ratingType.image)
                    .font(.title3)
            }
            Text("\(ratingType.rawValue)?")
                .lineLimit(1)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(bathroom: BathroomAttendant.shared.closestBathroom, rating: .constant(Rating.unknown), ratingType: .clean)
    }
}
