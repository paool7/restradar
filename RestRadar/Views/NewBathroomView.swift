//
//  NewBathroomView.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import SwiftUI
import TelemetryClient

struct NewBathroomView: View {
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var comment: String = ""
    @State private var category: Category = .store

    @Binding var isPresented: Bool

    var body: some View {
        List {
            Section {
                Text("Submit a publicly accessible bathroom to be reviewed and added to the list:")

                TextField("Name", text: $name)
                    .textContentType(.organizationName)
                TextField("Location", text: $location)
                    .textContentType(.fullStreetAddress)
                TextField("Other details?", text: $comment)
                Picker(selection: $category, label: Text("Category:")) {
                    ForEach(Category.allCases) { category in
                        Label(category.rawValue, systemImage: category.imageString).tag(category as Category)
                    }
                }
            }
        }.navigationTitle("New Bathroom")
            .toolbar {
                ToolbarItem {
                    Button("Submit", action: {
                        TelemetryManager.send("AddBathroom", with: ["name": self.name, "location": self.location, "comment": self.comment, "category": self.category.rawValue])
                        
                        LocationAttendant.shared.getLocation(from: self.location, completion: { location in
                            if let coordinate = location?.coordinate {
                                let id = self.location.randomizeAndHyphenate() + UUID().uuidString
                                
                                let bathroom = Bathroom(name: self.name, accessibility: .unknown, coordinate: coordinate, address: self.location, id: id, url: nil, category: self.category)
                                BathroomAttendant.shared.allBathrooms.insert(bathroom, at: 0)
                            }
                        })
                        self.isPresented = false
                    }).disabled(self.name.isEmpty || self.location.isEmpty)
                }
            }
    }
}
