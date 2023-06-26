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

struct RatingView: View {
    @StateObject var bathroom: Bathroom
    
    var type: String = "clean"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack {
                HStack {
                    if bathroom.visitRating == true || bathroom.visitRating == nil {
                        Button {
                            if bathroom.visitRating == nil {
                                TelemetryManager.send("Upvote", with: ["rating": "1", "buid": bathroom.id])
                                bathroom.visitRating = true
                            } else {
                                bathroom.visitRating = nil
                            }
                        } label: {
                            Group {
                                Image(systemName: bathroom.visitRating == true ? "hand.thumbsup.fill" : "hand.thumbsup")
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                    .padding(6)
                            }.background {
                                RoundedRectangle(cornerRadius: 12)
                                    .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                            }
                        }
                    }
                    
                    if bathroom.visitRating == false || bathroom.visitRating == nil {
                        Button {
                            if bathroom.visitRating == nil {
                                TelemetryManager.send("Downvote", with: ["rating": "0", "buid": bathroom.id])
                                bathroom.visitRating = false
                            } else {
                                bathroom.visitRating = nil
                            }
                        } label: {
                            Group {
                                Image(systemName: bathroom.visitRating == false ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                    .padding(6)
                            }.background {
                                RoundedRectangle(cornerRadius: 12)
                                    .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                            }
                        }
                    }
                }
                Text("visit rating")
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .scaledToFill()
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}
