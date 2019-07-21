//
//  InvoiceView.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/18/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import UIKit

class InvoiceView: UITableViewHeaderFooterView {
  
    @IBOutlet weak var lblTotalWithoutTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDiscountAmount: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTaxAmount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!

    let formatter = DecimalFormatter.sharedFormatter
    
    var invoice: Invoice? {
        didSet {
            if let invoice = invoice {
                lblTotalWithoutTax.text = formatter.string(from: invoice.totalWithoutTaxes)
                if  let discount = formatter.string(from: invoice.discount) {
                    lblDiscount.text = "Discount " + discount + "%"
                }
                lblDiscountAmount.text = formatter.string(from: invoice.discountAmount)
                if  let tax = formatter.string(from: invoice.tax) {
                    lblTax.text = "Tax " + tax + "%"
                }
                lblTaxAmount.text = formatter.string(from: invoice.taxAmount)
                lblTotalPrice.text = formatter.string(from: invoice.totalPrice)
            }
        }
    }
 
}
