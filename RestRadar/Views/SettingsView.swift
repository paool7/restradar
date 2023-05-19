//
//  SettingsView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI
import Shiny

struct SettingsView: View {
    @ObservedObject var attendant = SettingsAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
    @ObservedObject var eventsRepository = EventsRepository.shared
    
    @State private(set) var selectedAppIcon: AppIcon = .primary

    let availableModes = TransportMode.allCases
    let themes = [Theme.sunsetsunrise, Theme.random]

    @State private var showCalendarPicker = false

    var body: some View {
        List {
            Section {
                Picker("Transport Method:", selection: $attendant.transportMode) {
                    ForEach(availableModes, id: \.self) {
                        Text($0.name)
                    }
                }
                
                if attendant.transportMode == .wheelchair {
                    Toggle("Electric", isOn: $attendant.useElectricWheelchair)
                        .tint(.mint)
                    if attendant.useElectricWheelchair {
                        Stepper("Wheelchair Speed: \(String(format: "%.1f", attendant.electricWheelchairSpeed)) mph", value: $attendant.electricWheelchairSpeed, in: 0.1...10.0, step: 0.1)
                    } else {
                        Stepper("Wheelchair Speed: \(String(format: "%.1f", attendant.wheelchairSpeed)) mph", value: $attendant.wheelchairSpeed, in: 0.1...10.0, step: 0.1)
                    }
                } else {
                    Stepper("Walking Speed: \(String(format: "%.1f", attendant.walkingSpeed)) mph", value: $attendant.walkingSpeed, in: 0.1...8.0, step: 0.1)
                    Stepper("Step Length: \(String(format: "%.1f", attendant.stepLength)) feet", value: $attendant.walkingSpeed, in: 0.1...8.0, step: 0.1)
                }
                Text("Walking Speed is used to estimate travel time to nearby bathrooms.\nStep Length is used to estimate step distance from nearby bathrooms.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Tuning:")
            }
            
//            Section {
//                Toggle("Plan Ahead", isOn:$attendant.useCalendarEvents)
//                .tint(.teal)
//
//                Text("Upcoming events from your selected calendars will be checked to identify bathrooms close by.")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//
//                if attendant.useCalendarEvents {
//                    Button {
//                        showCalendarPicker = true
//                        eventsRepository.loadEvents { events in
//                            if let events = events {
//                                for event in events {
//                                    if let location = event.structuredLocation?.geoLocation {
//                                        print(event.title)
//                                    }
//                                }
//                            }
//                        }
//                    } label: {
//                        Text("Choose Calendars")
//                            .foregroundColor(.teal)
//                    }
//                }
//            } header: {
//                Text("Calendar:")
//            }
            
//            Section {
//                TextField("Heading Filter", text: $attendant.headingStringValue)
//                    .keyboardType(.numberPad)
//                Text("The minimum angular change in degrees relative to the last heading required to update the compass.")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            } header: {
//                Text("Compass:")
//            }
//
            Section {
                Picker("Primary Hand:", selection: $attendant.primaryHand) {
                    ForEach(Handed.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                
                Text("Important buttons will appear on the side of your primary hand.")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Picker("Theme:", selection: $attendant.gradientTheme) {
                    ForEach(themes, id: \.self) {
                        Text($0.name)
                    }
                }
                Toggle("Update Hourly:", isOn: $attendant.useTimeGradients)
                    .tint(.teal)
                Text(attendant.useTimeGradients ? "Gradient colors will update automatically every hour." : "Only your selected gradient color will be shown.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach((0...23), id: \.self) { i in
                                Button {
                                    attendant.gradientHour = Double(i)
                                } label: {
                                    LinearGradient(gradient: Gradient.gradient(forHour: i), startPoint: .top, endPoint: .bottom)
                                        .mask {
                                            CompassShapeView(rotation: locationAttendant.currentHeading ?? 0.0)
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .shadow(color: .primary.opacity(0.5), radius: 1)
                                        .background {
                                            if attendant.useTimeGradients == true {
                                                Circle()
                                                    .foregroundColor(Int(locationAttendant.currentHourValue) == i ? .secondary : .clear)
                                            } else {
                                                Circle()
                                                    .foregroundColor(Int(attendant.gradientHour) == i ? .secondary : .clear)
                                            }
                                        }
                                        .frame(height: 60)
                                        .frame(width: 60)
                                }
                            }
                        }
                    }.frame(height: 60)
                        .onAppear {
                            if attendant.useTimeGradients == true {
                                proxy.scrollTo(Int(locationAttendant.currentHourValue))
                            } else {
                                proxy.scrollTo(Int(attendant.gradientHour))
                            }
                        }
                        .onChange(of: attendant.useTimeGradients) { useTime in
                            if useTime == true {
                                proxy.scrollTo(Int(locationAttendant.currentHourValue))
                            } else {
                                proxy.scrollTo(Int(attendant.gradientHour))
                            }
                        }
                }
                Divider()
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(AppIcon.allCases) { icon in
                                Button {
                                    self.updateAppIcon(to: icon)
                                } label: {
                                    Image(icon.rawValue + "-Preview")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit
                                        )
                                        .frame(height: 102)
                                        .frame(width: 102)
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }.frame(height: 102)
                }
            } header: {
                Text("Customization:")
            }
        }
        .listStyle(.grouped)
        .navigationTitle("RestRadar")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCalendarPicker) {
            CalendarChooser(calendars: self.$eventsRepository.selectedCalendars, eventStore: self.eventsRepository.eventStore)
        }
        .onAppear{
            if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
                self.selectedAppIcon = appIcon
            }
        }
    }
    
    func updateAppIcon(to icon: AppIcon) {
        let previousAppIcon = selectedAppIcon
        selectedAppIcon = icon

        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.iconName else {
                /// No need to update since we're already using this icon.
                return
            }

            do {
                try await UIApplication.shared.setAlternateIconName(icon.iconName)
            } catch {
                /// We're only logging the error here and not actively handling the app icon failure
                /// since it's very unlikely to fail.
                print("Updating icon to \(String(describing: icon.iconName)) failed.")

                /// Restore previous app icon
                selectedAppIcon = previousAppIcon
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
