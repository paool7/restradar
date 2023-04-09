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
                Picker("Transport Mode:", selection: $attendant.transportMode) {
                    ForEach(availableModes, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.segmented)
                
                if attendant.transportMode == .wheelchair {
                    Toggle("Electric", isOn: $attendant.useElectricWheelchair)
                    Stepper("Wheelchair Speed (mph)", value: $attendant.walkingSpeed, in: 0.1...10.0)
                } else {
                    Stepper("Walking Speed (mph)", value: $attendant.walkingSpeed, in: 0.1...8.0)
                }
                
            } header: {
                Text("Transport Mode:")
            }
        }
        .navigationTitle("Tuning:")
        .navigationBarTitleDisplayMode(.large)
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
