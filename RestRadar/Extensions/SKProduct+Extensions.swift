//
//  SKProduct+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation
import StoreKit

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }
}
