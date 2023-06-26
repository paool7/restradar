//
//  String+Extensions.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation

extension String {
    func removeNewLine() -> String {
        return self.replacingOccurrences(of: "\n", with: ", ")
    }
}
