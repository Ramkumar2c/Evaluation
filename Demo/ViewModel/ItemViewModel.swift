//
//  ItemViewModel.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/18/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import Foundation

enum ItemError: Error {
    case parseError(String)
}

class ItemViewModel {
    var bill: Bill!     // Implicit unwrapping 
    init() {
        bill = Bill()
    }
    let formatter = DecimalFormatter.sharedFormatter
    
    func getItems() -> [Item]? {
        guard let bill = self.bill else {
            return nil
        }
        return bill.items
    }
    
    func getInvoice(state: State) -> Invoice? {
        return calculateInvoice(state: state)
    }
    
    func addItem(name: String, quantity: String, unitPrice: String, state:State) throws {
        guard let unit = formatter.decimalNumberFromString(string: unitPrice) else {
            throw ItemError.parseError("Invalid unit price")
        }
        guard let quanityValue = Int(quantity), quanityValue > 0 else {
            throw ItemError.parseError("Invalid Quanity")
        }
        let item = Item.init(itemName: name, quantity: quanityValue, unitPrice: unit, totalPrice: unit.multiplying(by: NSDecimalNumber.init(value: quanityValue)))
        bill.items.append(item)
     }
    
    func removeItemAtIndex(index: Int) throws {
        if index >= bill.items.count {
            throw ItemError.parseError("Invalid index to remove Item")
        }
        bill.items.remove(at: index)
    }
    
    private func calculateInvoice(state: State) -> Invoice? {
        let totalPriceWithoutTaxes = bill.items.reduce(0) { (amount, item) -> NSDecimalNumber in
            return item.totalPrice.adding(amount)
        }
        let discount = findDiscount(amount: totalPriceWithoutTaxes)
        let discountAmount = totalPriceWithoutTaxes.multiplying(by: discount.dividing(by: 100))
        let totalTax = (totalPriceWithoutTaxes.subtracting(discountAmount)).multiplying(by: state.tax.dividing(by: 100))
        let totalPrice = (totalPriceWithoutTaxes.subtracting(discountAmount)).adding(totalTax)
        bill.invoice = Invoice(totalWithoutTaxes: totalPriceWithoutTaxes, discount: discount, discountAmount: discountAmount, tax:state.tax, taxAmount: totalTax, totalPrice: totalPrice)
        return bill.invoice
    }
    
    func findDiscount(amount: NSDecimalNumber) -> NSDecimalNumber {
        if amount.compare(50000) == .orderedDescending {
            return 15
        }
        else if amount.compare(10000) == .orderedDescending {
            return 10
        }
        else if amount.compare(7000) == .orderedDescending {
            return 7
        }
        else if amount.compare(5000) == .orderedDescending {
            return 5
        }
        else if amount.compare(1000) == .orderedDescending {
            return 3
        }
        return 0
    }
    
}
