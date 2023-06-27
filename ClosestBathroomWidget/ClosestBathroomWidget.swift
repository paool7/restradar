//
//  ClosestBathroomWidget.swift
//  ClosestBathroomWidget
//
//  Created by Paul Dippold on 4/13/23.
//

import WidgetKit
import SwiftUI
import CoreLocation
import TelemetryClient

struct ClosestBathoomEntry: TimelineEntry {
    let date: Date
    let bathroom: Bathroom
    let size: WidgetFamily
}

struct ClosestBathroomLockScreenWidgetView: View {
    let entry: ClosestBathoomEntry
    
    let locationAttendant = LocationAttendant.shared
    let bathroomAttendant = BathroomAttendant.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(entry.bathroom.name)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
            }
            
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("\(entry.bathroom.totalTime() ?? 0)")
                            .font(.headline)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                        Image(systemName: "hourglass")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }.frame(maxWidth: .infinity)
                }.fixedSize(horizontal: true, vertical: false)

                Divider()
                    .overlay(.white)

                VStack(alignment: .leading) {
                    HStack(alignment:.center) {
                        Text("\(entry.bathroom.totalBlocks)")
                            .font(.headline)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                        Image(systemName: "building.2")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }.frame(maxWidth: .infinity)
                }.fixedSize(horizontal: true, vertical: false)

                Divider()
                    .overlay(.white)
                
                HStack(alignment: .center) {
                    Text("In")
                        .font(.headline)
                        .minimumScaleFactor(0.25)
                        .foregroundColor(.white)
                    entry.bathroom.category.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: true, vertical: false)
            }
            .frame(maxWidth: .infinity)
        }
        .widgetURL({
            if let url = URL(string: "restradar://\(entry.bathroom.id)") {
                return url
            }
             return nil
        }())
    }
}

struct ClosestBathroomHomeScreenWidgetView: View {
    let entry: ClosestBathoomEntry
    
    let locationAttendant = LocationAttendant.shared
    let bathroomAttendant = BathroomAttendant.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.bathroom.name)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                
             Spacer()
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(entry.bathroom.category.backgroundColor)
                        .overlay {
                            entry.bathroom.category.image
                                .font(.subheadline)
                                .foregroundColor(entry.bathroom.category.backgroundColor.accessibleFontColor)
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize * 2 )
                }
            }
            Divider()
                .overlay(.white)
            HStack {
                VStack(alignment: .leading) {
                    HStack() {
                        Text("\(entry.bathroom.totalTime() ?? 0)")
                            .font(.largeTitle)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                        Image(systemName: "hourglass")
                            .foregroundColor(.white)
                            .font( .title3)
                    }
                    Text("mins")
                        .font(.caption)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                }
                
                Divider()
                    .overlay(.white)
                VStack(alignment: .leading) {
                    HStack {
                        if let distanceString = entry.bathroom.distanceString(withUnit: false) {
                            Text(distanceString)
                                .lineLimit(1)
                                .font(.largeTitle)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                        }
                        
                        SettingsAttendant.shared.distanceMeasurement.image
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    Text(SettingsAttendant.shared.distanceMeasurement.name.lowercased())
                        .font(.caption)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                }
            }
            Divider()
                .overlay(.white)
            DirectionsSummaryView(bathroom: entry.bathroom)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
        }.padding(16)
            .background {
                if let gradient = Gradient.forCurrentTime() {
                    LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                }
            }
        .widgetURL({
            if let url = URL(string: "restradar://\(entry.bathroom.id)") {
                return url
            }
             return nil
        }())
    }
}

struct ClosestBathroomWidgetView: View {
    let entry: ClosestBathoomEntry
    
    let locationAttendant = LocationAttendant.shared
    let bathroomAttendant = BathroomAttendant.shared
    
    var body: some View {
        if entry.size == .systemSmall {
            ClosestBathroomHomeScreenWidgetView(entry: entry)
        } else {
            ClosestBathroomLockScreenWidgetView(entry: entry)
        }
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
            _ = try await BathroomAttendant.shared.closestBathroom.getDirections()
            
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 5),
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
    
    init() {
        let configuration = TelemetryManagerConfiguration(appID: "0C0E329B-8526-4904-91D6-941255115F8B")
        TelemetryManager.initialize(with: configuration)
    }
    
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
