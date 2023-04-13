//
//  SettingsView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI

enum TransportMode: CaseIterable {
    case wheelchair
    case walking
    
    var name: String {
        switch self {
        case .wheelchair:
            return "Wheelchair"
        case .walking:
            return "Walking"
        }
    }
}

struct SettingsView: View {
    @ObservedObject var attendant = SettingsAttendant.shared

    var availableModes = TransportMode.allCases
    
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
                TextField("Heading Filter", text: $attendant.headingStringValue)
                    .keyboardType(.numberPad)
            } header: {
                Text("Compass:")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
