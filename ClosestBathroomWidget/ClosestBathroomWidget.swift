//
//  ClosestBathroomWidget.swift
//  ClosestBathroomWidget
//
//  Created by Paul Dippold on 4/13/23.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct ClosestBathoomEntry: TimelineEntry {
    let date: Date
    let bathroom: Bathroom
    let size: WidgetFamily
}

struct ClosestBathroomWidgetView: View {
    let entry: ClosestBathoomEntry
    
    let locationAttendant = LocationAttendant.shared
    let bathroomAttendant = BathroomAttendant.shared
    
    var body: some View {
        BathroomSummaryView(bathroom: .constant(entry.bathroom))
        .background {
            if entry.size == .systemSmall, let gradient = Gradient.forCurrentTime() {
                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
            }
        }
        .widgetURL(URL(string: "restradar://\(entry.bathroom.id)")!)
    }
}

struct ClosestBathroomTimelineProvider: TimelineProvider {
    typealias Entry = ClosestBathoomEntry
    let locationAttendant = LocationAttendant.shared

    func placeholder(in context: Context) -> Entry {
        return Entry(date: Date(), bathroom: BathroomAttendant.shared.closestBathroom, size: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        Task {
            let closestBathroom = try await BathroomAttendant.shared.findClosestBathrooms()
            let entry = ClosestBathoomEntry(date: Date(), bathroom: closestBathroom, size: context.family)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            _ = try await locationAttendant.fetchLocation()
            _ = try await locationAttendant.getDirections(toId: BathroomAttendant.shared.closestBathroom.id)
            
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 3),
                to: Date()
            )!
            let entry = ClosestBathoomEntry(date: nextUpdate, bathroom: BathroomAttendant.shared.closestBathroom, size: context.family)
            
            let timeline = Timeline(
                entries: [entry],
                policy: .atEnd
            )
            
            completion(timeline)
        }
    }
}

@main
struct ClosestBathroomWidget: Widget {
    let kind = "com.paool.bathroom.ClosestBathroomView"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: ClosestBathroomTimelineProvider()
        ) { entry in
            ClosestBathroomWidgetView(entry: entry)
        }
        .configurationDisplayName("Closest Bathroom")
        .description("Find the closest bathroom near you.")
        .supportedFamilies([
            .systemSmall,
            .accessoryRectangular
        ])
    }
}
