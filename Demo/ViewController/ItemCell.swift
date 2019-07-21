//
//  ItemCell.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/17/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import UIKit

protocol ItemCellDelegate {
    func didTapRemove(sender: ItemCell, item:Item)
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblUnitPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    let formatter = DecimalFormatter.sharedFormatter

    var delegate: ItemCellDelegate?

    var item: Item? {
        didSet {
            if let item = item {
                lblItem.text = item.itemName
                lblQuantity.text = String(item.quantity)
                lblUnitPrice.text = formatter.string(from: item.unitPrice)
                lblTotalPrice.text = formatter.string(from: item.totalPrice)
            }
        }
    }

    @IBAction func didTapRemove(_ sender: UIButton) {
        if let item = item {
            delegate?.didTapRemove(sender: self, item: item)
        }
    }
  
}
