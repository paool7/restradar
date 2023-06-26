//
//  SettingsView.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import Karte
import MessageUI
import RevenueCat
import Shiny
import StoreKit
import SwiftUI
import TelemetryClient

struct SettingsView: View {
    @ObservedObject var attendant = SettingsAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
            
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
    
    @State private var showThemeAlert = false

    var body: some View {
        List {
            Section {
                if !purchasedProductIdentifiers.isEmpty {
                    VStack(alignment: .leading) {
                        Text("App Icon: ")
                            .foregroundColor(.primary)
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(AppIcon.allCases) { icon in
                                        Button {
                                            self.updateAppIcon(to: icon)
                                        } label: {
                                            Image(icon.rawValue + "-Preview")
                                                .resizable()
                                                .aspectRatio(1.0, contentMode: .fit)
                                                .frame(height: 102)
                                                .cornerRadius(16)
                                                .if(attendant.selectedAppIcon == icon) {
                                                    $0.overlay {
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(Color.secondary, lineWidth: 4)
                                                    }
                                                }
                                        }
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
                            }
                        }
                    }
                }
                
                Picker("Theme:", selection: $attendant.gradientTheme) {
                    ForEach(Theme.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach((0...23), id: \.self) { i in
                                Button {
                                    attendant.gradientHour = Double(i)
                                    attendant.useTimeGradients = false
                                } label: {
                                    LinearGradient(gradient: Gradient.gradient(forHour: i), startPoint: .top, endPoint: .bottom)
                                        .mask {
                                            CompassShapeView(rotation: (locationAttendant.currentHeading ?? 0.0) + (Double(i) * 10.0))
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .shadow(color: .primary.opacity(0.5), radius: 1)
                                        .background {
                                            if attendant.useTimeGradients == false {
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
                Toggle("Update Hourly:", isOn: $attendant.useTimeGradients)
                    .tint(.teal)
                Text(attendant.useTimeGradients ? "Gradient colors will update automatically every hour." : "Only your selected gradient color will be shown.")
                    .font(.body)
                    .foregroundColor(.secondary)
            } header: {
                Text("Customization:")
            }.alert(isPresented: $showThemeAlert) {
                Alert(title: Text("Update Hourly must be disabled to select colors manually."), dismissButton: .default(Text("Ok")))
            }
            
            Section {
                Text("Please submit any bugs, issues, questions, or ideas and I will get back to you as soon as possible.")
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
                    Text("You can support the continued development of this app with an optional tip.\n(Alternate app icons will also be unlocked)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                if !self.purchasedProductIdentifiers.contains(where: { $0 == self.productIdentifiers.first}), let product = self.dollarProduct {
                    Button {
                        self.purchasingDollarProduct = true
                        self.makePurchase(product: product)
                    } label: {
                        HStack(spacing: 4) {
                            Text("$1 Tip 🍪")
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
                            Text("$3 Tip 🧁")
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
                            Text("$5 Tip 🍰")
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
                Alert(title: Text("Thank you so much for your generosity!"), message: Text("Please submit any ideas for fixes, improvements, or new features and I will make them a priority.\n\nAlternate app icons have been unlocked!"), dismissButton: .default(Text("Ok")))
            }
            
            
            Section {
                let installedApps = Karte.App.allCases.filter({ Karte.isInstalled($0) })
                Picker("Preferred Maps App:", selection: $attendant.mapProvider) {
                    ForEach(installedApps, id: \.self) {
                        Text($0.name)
                    }
                }
                Picker("Transport Method:", selection: $attendant.transportMode) {
                    ForEach(TransportMode.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                
                Picker("Distance Unit:", selection: $attendant.distanceMeasurement) {
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
                    Text("\(attendant.transportMode.name) Speed is used to estimate travel time to nearby bathrooms.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    Stepper("Walking Speed: \(String(format: "%.1f", attendant.walkingSpeed)) mph", value: $attendant.walkingSpeed, in: 0.1...8.0, step: 0.1)
                    Text("\(attendant.transportMode.name) Speed is used to estimate travel time to nearby bathrooms.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Stepper("Step Length: \(String(format: "%.1f", attendant.stepLength)) feet", value: $attendant.stepLength, in: 0.1...8.0, step: 0.1)
                    Text("Step Length is used to estimate step distance from nearby bathrooms.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Stepper("Compass Heading Filter: \(String(format: "%.1f", attendant.headingFilter))", value: $attendant.headingFilter, in: 0.0...45.0, step: 1.0)
                Text("The minimum angular change in degrees relative to the last heading required to update the compass.\nHigher values will reduce map movement as you move.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Tuning:")
            }
        }
        .listStyle(.grouped)
        .navigationTitle("RestRadar")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
                attendant.selectedAppIcon = appIcon
            }
            
            Purchases.shared.getCustomerInfo { (customerInfo, error) in
                if let identifiers = customerInfo?.allPurchasedProductIdentifiers {
                    self.purchasedProductIdentifiers.append(contentsOf: identifiers)
                }
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
        }
    }
    
    func updateAppIcon(to icon: AppIcon) {
        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.iconName else {
                /// No need to update since we're already using this icon.
                return
            }
            
            do {
                try await UIApplication.shared.setAlternateIconName(icon.iconName)
                attendant.selectedAppIcon = icon
            } catch {
                let errorMessage = "Updating icon to \(String(describing: icon.iconName)) failed."
                print(errorMessage)
                TelemetryManager.send("Error", with: ["type": "AppIcon", "message": errorMessage])
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
            } else if let error {
                TelemetryManager.send("Error", with: ["type": "Purchase", "message": error.localizedDescription])
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
