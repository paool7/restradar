//
//  LocationSearchView.swift
//  G2G
//
//  Created by Paul Dippold on 4/9/23.
//

import SwiftUI
import MapKit
import Combine

struct LocationSearchView: View {
    @ObservedObject var locationService: LocationService
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    if locationAttendant.selectedSearchLocation != nil {
                        Section {
                            Button {
                                locationAttendant.selectedSearchLocation = nil

                                dismiss()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Use Current Location")
                                        .foregroundColor(.mint)
                                    Spacer()
                                }
                            }
                        }
                    }
                    Section(header: Text("Location Search")) {
                        ZStack(alignment: .trailing) {
                            TextField("Search", text: $locationService.queryFragment)
                            // This is optional and simply displays an icon during an active search
                            if locationService.status == .isSearching {
                                Image(systemName: "clock")
                                    .foregroundColor(Color.gray)
                            }
                        }
                    }
                    Section(header: Text("Results")) {
                        List {
                            switch locationService.status {
                            case .noResults: AnyView(Text("No Results")).foregroundColor(Color.gray)
                            case .error(let description): AnyView(Text("Error: \(description)")).foregroundColor(Color.gray)
                            default: AnyView(EmptyView())
                            }
                            
                            ForEach(locationService.searchResults, id: \.self) { completionResult in
                                // This simply lists the results, use a button in case you'd like to perform an action
                                // or use a NavigationLink to move to the next view upon selection.
                                Button {
                                    if locationAttendant.selectedSearchLocation == completionResult {
                                        locationAttendant.selectedSearchLocation = nil
                                    } else {
                                        locationAttendant.selectedSearchLocation = completionResult
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, content: {
                                            Text(completionResult.title)
                                            Text(completionResult.subtitle)
                                                .font(.callout)
                                        })
                                        Spacer()
                                        if locationAttendant.selectedSearchLocation == completionResult {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(.mint)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button {
                        if locationAttendant.selectedSearchLocation != nil {
                            locationAttendant.selectedSearchLocation = nil
                        }
                        
                        dismiss()
                    } label: {
                        Text(locationAttendant.selectedSearchLocation != nil ? "Clear" : "Cancel")
                    }
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    if let selected = locationAttendant.selectedSearchLocation {
                        Button {
                            locationAttendant.getLocation(from: "\(selected.title) \(selected.subtitle)") { location in
                                locationAttendant.selectedSearchLocation = selected
                                locationAttendant.current = location

                                dismiss()

                            }
                        } label: {
                            Text("Done")
                        }
                    }
                })
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(locationService: LocationAttendant.shared.locationService)
    }
}

class LocationService: NSObject, ObservableObject {

    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }

    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []

    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self

        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            // we're debouncing the search, because the search completer is rate limited.
            // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.status = .idle
                    self.searchResults = []
                }
        })
    }
}

extension LocationService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Depending on what you're searching, you might need to filter differently or
        // remove the filter altogether. Filtering for an empty Subtitle seems to filter
        // out a lot of places and only shows cities and countries.
        self.searchResults = completer.results
        self.status = completer.results.isEmpty ? .noResults : .result
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}
