//
//  DecimalFormatter.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/19/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import UIKit

class DecimalFormatter: Formatter {
    
    public static let sharedFormatter = DecimalFormatter()
    private var systemNumberFormatter = NumberFormatter()
    
    public override init() {
        super.init()
        let numberOfDecimals = 2
        systemNumberFormatter.generatesDecimalNumbers = true
        systemNumberFormatter.maximumFractionDigits = numberOfDecimals
        systemNumberFormatter.minimumFractionDigits = numberOfDecimals
        systemNumberFormatter.numberStyle = .decimal
        systemNumberFormatter.alwaysShowsDecimalSeparator = true
        systemNumberFormatter.usesGroupingSeparator = false
    }
    
    public func string(from decimalNumber: NSDecimalNumber) -> String? {
        guard decimalNumber != NSDecimalNumber.notANumber else {
            return nil
        }
        return systemNumberFormatter.string(from: decimalNumber)
    }
    
    public func decimalNumberFromString(string: String, roundingScale: Int16 = 2) -> NSDecimalNumber? {
        guard let number = systemNumberFormatter.number(from: string) as? NSDecimalNumber else {
            return nil
        }
        
        let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: roundingScale, raiseOnExactness: false,
                                              raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return number.rounding(accordingToBehavior: behavior)
    }
    
    public override func string(for obj: Any?) -> String? {
        guard let decimalNumber = obj as? NSDecimalNumber else {
            return nil
        }
        return string(from: decimalNumber)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
