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
        VStack(alignment: .center, spacing: 2) {
            HStack{
                Text(entry.bathroom.name)
                    .lineLimit(2)
                    .font(.headline)
                    .bold()
                    .minimumScaleFactor(0.2)
                    .foregroundColor(.white)
                if entry.size == .systemSmall {
                    Image(systemName: entry.bathroom.code != nil ? "lock" : "lock.open")
                        .foregroundColor(.white)
                        .font(entry.size == .systemSmall ? .title3 : .subheadline)
                        .bold()
                    Spacer()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: entry.size == .systemSmall ? 4 : 0, trailing: 0))
            if let totalBlocks = entry.bathroom.totalBlocks, let current = locationAttendant.current, let timeAway = entry.bathroom.totalTime(current: current) {
                HStack {
                    if entry.size != .systemSmall {
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("\(timeAway)")
                                .font(entry.size == .systemSmall ? .largeTitle : .headline)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                            Image(systemName: "hourglass")
                                .foregroundColor(.white)
                                .font(entry.size == .systemSmall ? .title3 : .subheadline)
                        }.frame(maxWidth: .infinity)
                        if entry.size == .systemSmall {
                            Text("mins")
                                .font(.caption)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                        }
                    }.fixedSize(horizontal: true, vertical: false)
                    if entry.size == .systemSmall {
                        Spacer()
                    }
                    Divider()
                        .overlay(.white)
                    if entry.size == .systemSmall {
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        HStack(alignment:.center) {
                            Text("\(totalBlocks)")
                                .font(entry.size == .systemSmall ? .largeTitle : .headline)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                            Image(systemName: "building.2")
                                .foregroundColor(.white)
                                .font(entry.size == .systemSmall ? .title3 : .subheadline)
                        }.frame(maxWidth: .infinity)
                        if entry.size == .systemSmall {
                            Text("blocks")
                                .font(.caption)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                        }
                    }.fixedSize(horizontal: true, vertical: false)
                    if entry.size != .systemSmall {
                        Divider()
                            .overlay(.white)
                        
                        HStack(alignment: .center) {
                            if let code = entry.bathroom.code {
                                Text(code)
                                    .font(entry.size == .systemSmall ? .largeTitle : .headline)
                                    .minimumScaleFactor(0.25)
                                    .foregroundColor(.white)
                            }
                            Image(systemName: entry.bathroom.code != nil ? "lock" : "lock.open")
                                .font(entry.size == .systemSmall ? .title3 : .subheadline)
                                .foregroundColor(.white)
                                .bold()
                        }.frame(maxWidth: .infinity)
                        .fixedSize(horizontal: true, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: entry.size == .systemSmall ? 4 : 0, trailing: 0))
            }

            if entry.size == .systemSmall {
                Divider()
                    .overlay(.white)
                LazyHStack {
                    Image(systemName: "figure.walk")
                        .font(.title2)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                    ForEach(entry.bathroom.directions, id: \.hash) { step in
                        if let index = entry.bathroom.indexFor(step: step), index >= entry.bathroom.currentRouteStepIndex ?? index {
                            Image(systemName: entry.bathroom.imageFor(step: step))
                                .font(step == entry.bathroom.currentRouteStep() ? .title : .title2)
                                .foregroundColor(.white)
                                .if(step == entry.bathroom.currentRouteStep()) { $0.bold() }
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading:12, bottom: 8, trailing: 12))
        .background {
            if entry.size == .systemSmall, let gradient = Gradient.forCurrentTime() {
                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
            }
        }
        .widgetURL(URL(string: "g2g://\(entry.bathroom.id)")!)
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
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}
