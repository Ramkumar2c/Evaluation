//
//  Util.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/19/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import Foundation

class Util {
    static let formatter = Formatter()
    static func limitCharacters(_ text: String, inRange range: NSRange, replacementString string: String, limitBy: Int) -> Bool {
        guard let range = Range(range, in: text) else { return false }
        let text = text.replacingCharacters(in: range, with: string)
        return text.count < limitBy
    }
    
    static func validateDecimal(_ text: String, inRange range: NSRange, replacementString string: String) -> Bool {
        guard let range = Range(range, in: text) else { return false }
        let text = text.replacingCharacters(in: range, with: string)
        let expression = "^[0-9]{0,5}$*((\\.|,)[0-9]{0,2})?$"
        let regex = try? NSRegularExpression(pattern: expression, options: .caseInsensitive)
        let numberOfMatches: Int? = regex?.numberOfMatches(in: text, options: [], range: NSRange(location: 0, length: text.count ))
        return numberOfMatches != 0
    }
    
    static func validateInput(name: String, quantity: String, price: String, state: State?) -> Bool {
        return !(name.isEmpty || quantity.isEmpty || price.isEmpty || state == nil)
    }

}
