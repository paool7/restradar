//
//  FIlteringView.swift
//  G2G
//
//  Created by Paul Dippold on 4/14/23.
//

import SwiftUI

struct FilteringView: View {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section {
                
            } 
        }
        .listStyle(.plain)
        .navigationTitle("Filter:")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {

                    dismiss()
                } label: {
                    Text("Cancel")
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    dismiss()

                } label: {
                    Text("Done")
                }
            })
        }
    }
}

struct FilteringView_Previews: PreviewProvider {
    static var previews: some View {
        FilteringView()
    }
}
