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
    
    func randomizeAndHyphenate() -> String {
        var words = self.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        words.shuffle()
        
        let hyphenated = words.joined(separator: "-")
        return hyphenated
    }
}
