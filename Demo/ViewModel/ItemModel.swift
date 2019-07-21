//
//  ItemModel.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/18/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import Foundation

struct Bill {
    var items = [Item]()
    var invoice: Invoice?
}

struct Invoice {
    let totalWithoutTaxes: NSDecimalNumber
    let discount: NSDecimalNumber
    let discountAmount: NSDecimalNumber
    let tax: NSDecimalNumber
    let taxAmount: NSDecimalNumber
    let totalPrice: NSDecimalNumber
}

struct Item {
    let itemName: String
    let quantity: Int
    let unitPrice: NSDecimalNumber
    let totalPrice: NSDecimalNumber
}

struct State {
    let name: String
    let tax: NSDecimalNumber
}
