//
//  SettingsView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import SwiftUI
import Shiny
import RevenueCat
import StoreKit
import MessageUI

struct SettingsView: View {
    @ObservedObject var attendant = SettingsAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
    
    @State private(set) var selectedAppIcon: AppIcon = .primary

    let availableModes = TransportMode.allCases
    let themes = [Theme.sunsetsunrise, Theme.random]
    
    @State var dollarProduct: StoreProduct?
    @State var dollar3Product: StoreProduct?
    @State var dollar5Product: StoreProduct?
    @State private var showingAlert = false
    @State var purchasingDollarProduct = false
    @State var purchasingDollar3Product = false
    @State var purchasingDollar5Product = false
    
    private let productIdentifiers = ["restradar.1dollar","restradar.3dollar","restradar.5dollar"]
    @State private var purchasedProductIdentifiers: [String] = []
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false

    var body: some View {
        List {
            Section {
                Picker("Transport Method:", selection: $attendant.transportMode) {
                    ForEach(availableModes, id: \.self) {
                        Text($0.name)
                    }
                }
                
                Picker("Distance Measurement:", selection: $attendant.distanceMeasurement) {
                    ForEach(DistanceMeasurement.allCases, id: \.self) {
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
                    Text("\(SettingsAttendant.shared.transportMode.name) Speed is used to estimate travel time to nearby bathrooms.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    Stepper("Walking Speed: \(String(format: "%.1f", attendant.walkingSpeed)) mph", value: $attendant.walkingSpeed, in: 0.1...8.0, step: 0.1)
                    Text("\(SettingsAttendant.shared.transportMode.name) Speed is used to estimate travel time to nearby bathrooms.\nStep Length is used to estimate step distance from nearby bathrooms.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Stepper("Step Length: \(String(format: "%.1f", attendant.stepLength)) feet", value: $attendant.walkingSpeed, in: 0.1...8.0, step: 0.1)
                    Text("Step Length is used to estimate step distance from nearby bathrooms.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
//                TextField("Compass Heading Filter", text: $attendant.headingStringValue)
//                    .keyboardType(.numberPad)
//                Text("The minimum angular change in degrees relative to the last heading required to update the compass.")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
            } header: {
                Text("Tuning:")
            }
            
            Section {
                Text("Please submit any bugs, issues, or ideas for improvements or new features and I will get back to you as soon as possible.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Button(action: {
                    self.isShowingMailView.toggle()
                }) {
                    Text("Submit Issue or Idea")
                }
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$result)
                }
                
                if !self.purchasedProductIdentifiers.contains(where: { $0 == self.productIdentifiers[2] && $0 == self.productIdentifiers[1] && $0 == self.productIdentifiers[0] }) {
                    Text("You can also support the continued development of this app with an optional tip.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                if !self.purchasedProductIdentifiers.contains(where: { $0 == self.productIdentifiers.first}), let product = self.dollarProduct {
                    Button {
                            self.purchasingDollarProduct = true
                            self.makePurchase(product: product)
                    } label: {
                        HStack(spacing: 4) {
                            Text("1 Dollar Tip")
                            if self.purchasingDollarProduct {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(self.purchasingDollarProduct || self.purchasingDollar3Product || self.purchasingDollar5Product)
                }
                
                if !self.purchasedProductIdentifiers.contains(where: { $0 == self.productIdentifiers[1]}), let product = self.dollar3Product {
                    Button {
                        self.purchasingDollar3Product = true
                        self.makePurchase(product: product)
                    } label: {
                        HStack(spacing: 4) {
                            Text("3 Dollar Tip")
                            if self.purchasingDollar3Product {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(self.purchasingDollarProduct || self.purchasingDollar3Product || self.purchasingDollar5Product)
                }
                if !self.purchasedProductIdentifiers.contains(where: { $0 == self.productIdentifiers[2]}), let product = self.dollar5Product {
                    Button {
                        self.purchasingDollar5Product = true
                        self.makePurchase(product: product)
                    } label: {
                        HStack(spacing: 4) {
                            Text("5 Dollar Tip")
                            if self.purchasingDollar5Product {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(self.purchasingDollarProduct || self.purchasingDollar3Product || self.purchasingDollar5Product)
                }
            } header: {
                Text("Support:")
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Thank you so much for your generosity!"), message: Text("Please submit any ideas for fixes, improvements, or new features and I will make them a priority.\n\nAlternative app icons have also been unlocked!"), dismissButton: .default(Text("Ok")))
            }
            
            Section {
                Picker("Buttons:", selection: $attendant.primaryHand) {
                    ForEach(Handed.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                
                Text("Important buttons will appear on the specified side of the screen.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                if !purchasedProductIdentifiers.isEmpty {
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
                }

                Picker("Theme:", selection: $attendant.gradientTheme) {
                    ForEach(themes, id: \.self) {
                        Text($0.name)
                    }
                }
                Toggle("Update Hourly:", isOn: $attendant.useTimeGradients)
                    .tint(.teal)
                Text(attendant.useTimeGradients ? "Gradient colors will update automatically every hour." : "Only your selected gradient color will be shown.")
                    .font(.body)
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
                                            CompassShapeView(rotation: (locationAttendant.currentHeading ?? 0.0) + (Double(i) * 10.0))
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
            } header: {
                Text("Customization:")
            }
        }
        .listStyle(.grouped)
        .navigationTitle("RestRadar")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
                self.selectedAppIcon = appIcon
            }
            
            Purchases.shared.getProducts(productIdentifiers) { products in
                for product in products {
                    if product.productIdentifier == "restradar.1dollar" {
                        self.dollarProduct = product
                    } else if product.productIdentifier == "restradar.3dollar" {
                        self.dollar3Product = product
                    } else if product.productIdentifier == "restradar.5dollar" {
                        self.dollar5Product = product
                    }
                }
            }
            
            Purchases.shared.getCustomerInfo { (customerInfo, error) in
                if let identifiers = customerInfo?.allPurchasedProductIdentifiers {
                    self.purchasedProductIdentifiers.append(contentsOf: identifiers)
                }
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
    
    func makePurchase(product: StoreProduct) {
        Purchases.shared.purchase(product: product) { transaction, info, error, cancelled in
            self.purchasingDollarProduct = false
            self.purchasingDollar3Product = false
            self.purchasingDollar5Product = false

            if !cancelled && error == nil {
                Purchases.shared.getCustomerInfo { (customerInfo, error) in
                    if customerInfo?.originalPurchaseDate != nil {
                        showingAlert = true
                    }
                    if let identifiers = customerInfo?.allPurchasedProductIdentifiers {
                        self.purchasedProductIdentifiers.append(contentsOf: identifiers)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }
}
