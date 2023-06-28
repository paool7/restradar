//
//  PurchaseAttendant.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/27/23.
//

import Foundation
import RevenueCat

class PurchaseAttendant: ObservableObject {
    static let shared = PurchaseAttendant()
    
    @Published var hasTipped: Bool
    
    init() {
        self.hasTipped = true
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.allPurchasedProductIdentifiers.count == 0 {
                self.hasTipped = false
            }
        }
    }
}
