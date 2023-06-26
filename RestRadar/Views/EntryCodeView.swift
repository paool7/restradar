//
//  EntryCodeView.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation

import Karte
import MapKit
import MessageUI
import SafariServices
import Shiny
import SwiftUI
import TelemetryClient

struct EntryCodeView: View {
    @StateObject var bathroom: Bathroom
    
    @State private var presentAlert = false
    @State private var code: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack {
                HStack {
                    Button {
                        self.presentAlert.toggle()
                    } label: {
                        Group {
                            HStack(spacing: 4) {
                                Image(systemName: "plus")
                                    .foregroundColor(.primary)
                                    .font(.headline)
                            }.padding(6)
                        }.background {
                            RoundedRectangle(cornerRadius: 12)
                                .shiny(Gradient.forCurrentTime() ?? .iridescent2)
                        }
                    }.alert("Entry Code", isPresented: $presentAlert, actions: {
                        TextField("Code", text: $code)
                        
                        Button("Save Code", action: {
                            if !self.code.isEmpty {
                                TelemetryManager.send("AddCode", with: ["code": self.code, "buid": bathroom.id])
                            }
                        })
                        Button("No Code", action: {
                            if !self.code.isEmpty {
                                TelemetryManager.send("NoCode", with: ["buid": bathroom.id])
                            }
                        })
                        Button("Cancel", role: .cancel, action: {})
                    }, message: {
                        Text("If a code was required to unlock the bathroom door please enter it here. Otherwise select \"No Code\".")
                    })
                    
                    Image(systemName: "lock.open.trianglebadge.exclamationmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Text("entry code")
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .scaledToFill()
            }
        }
    }
}

struct EntryCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EntryCodeView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}
