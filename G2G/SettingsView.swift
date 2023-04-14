//
//  SettingsView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var attendant = SettingsAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
    @ObservedObject var eventsRepository = EventsRepository.shared

    var availableModes = TransportMode.allCases
    
    @State private var showCalendarPicker = false

    var body: some View {
        List {
            Section {
                Picker("Transport Method:", selection: $attendant.transportMode) {
                    ForEach(availableModes, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.segmented)
                
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
                }
                Text("Speed is used to estimate travel time to nearby bathrooms.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Transport Method:")
            }
            
            Section {
                Toggle("Plan Ahead", isOn:$attendant.useCalendarEvents)
                .tint(.teal)
                
                Text("Upcoming events from your selected calendars will be checked to identify bathrooms close by.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if attendant.useCalendarEvents {
                    Button {
                        showCalendarPicker = true
                        eventsRepository.loadEvents { events in
                            print(events?.count)
                            if let events = events {
                                for event in events {
                                    if let location = event.structuredLocation?.geoLocation {
                                        print(event.title)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Choose Calendars")
                            .foregroundColor(.teal)
                    }
                }
            } header: {
                Text("Calendar:")
            }
            
            Section {
                TextField("Heading Filter", text: $attendant.headingStringValue)
                    .keyboardType(.numberPad)
            } header: {
                Text("Compass:")
            }
            
            Section {
                Toggle("Use current time to change compass gradient.", isOn: $attendant.useTimeGradients)
                    .tint(.teal)
                if !attendant.useTimeGradients {
                    VStack {
                        Text("Choose gradient:")
                        HStack(spacing: 4) {
                            Slider(value: $attendant.gradientHour, in: 0...23)
                            Gradient.gradient(forHour: Int(attendant.gradientHour))
                                .mask {
                                    CompassShapeView(rotation: .constant(0))
                                        .aspectRatio(contentMode: .fit)
                                        .shadow(radius: 4)
                                }
                                .frame(height: 60)
                                .frame(width: 60)
                        }
                    }
                } 
            } header: {
                Text("Colors:")
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCalendarPicker) {
            CalendarChooser(calendars: self.$eventsRepository.selectedCalendars, eventStore: self.eventsRepository.eventStore)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
