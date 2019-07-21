//
//  DemoTests.swift
//  DemoTests
//
//  Created by Ramkumar Chandrasekaran on 7/17/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import XCTest
@testable import Demo

class DemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: TEST TaxFactory
    
    func testTaxFactory() {
        XCTAssertTrue(TaxFactory.getStates().count > 0)
        XCTAssertNotNil(TaxFactory.getStateByName(name: "CA"))
        XCTAssertNil(TaxFactory.getStateByName(name: "INVALID STATE"))
        let state = TaxFactory.getStateByName(name: "ND")
        XCTAssertEqual(state?.name, "ND")
        XCTAssertEqual(state?.tax, 5)
    }
    
    //MARK: TEST Util

    func testUtil() {
        var text = "2424243"
        var result = Util.limitCharacters(text, inRange: NSRange.init(location: text.count, length: 0), replacementString: "4", limitBy: 5)
        XCTAssertFalse(result)
        
        text = "999"
        result = Util.limitCharacters(text, inRange: NSRange.init(location: text.count, length: 0), replacementString: "4", limitBy: 5)
        XCTAssertTrue(result)
        
        XCTAssertTrue(Util.validateInput(name: "name", quantity: "4", price: "44.2", state: State.init(name: "CA", tax: 5.5)))
        XCTAssertFalse(Util.validateInput(name: "", quantity: "", price: "", state: nil))
        XCTAssertFalse(Util.validateInput(name: "item name alone", quantity: "", price: "", state: nil))
        XCTAssertFalse(Util.validateInput(name: "", quantity: "4", price: "", state: State.init(name: "CA", tax: 5.5)))
        
        text = "999.9"
        result = Util.validateDecimal(text, inRange: NSRange.init(location: text.count, length: 0), replacementString: ".")
        XCTAssertFalse(result)
        
        text = "99"
        result = Util.validateDecimal(text, inRange: NSRange.init(location: text.count, length: 0), replacementString: ".")
        XCTAssertTrue(result)
    }

    //MARK: TEST StateSelectionViewController
    
    func testStateSelection() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let stateSelectionVC  = storyboard.instantiateViewController(withIdentifier: "STATEVC") as! StateSelectionViewController
        UIApplication.shared.keyWindow?.addSubview(stateSelectionVC.view)
        
        XCTAssertNotNil(stateSelectionVC)
        XCTAssertNotNil(stateSelectionVC.tableView)
        XCTAssertNotNil(stateSelectionVC.tableView.dataSource)
        XCTAssertNotNil(stateSelectionVC.tableView.delegate)
        
        let cell =  stateSelectionVC.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.textLabel?.text, "CA")
        XCTAssertEqual(cell?.detailTextLabel?.text, "8.50")
        
        XCTAssertNotNil(stateSelectionVC)
        XCTAssertTrue(stateSelectionVC.states.count > 0)
        stateSelectionVC.delegate = TestStateSelectionDelegate()
        stateSelectionVC.delegate?.didSelectState(sender: stateSelectionVC, state: stateSelectionVC.states.first!)
        XCTAssertNotNil(stateSelectionVC.delegate)
        
    }
    
    //MARK: TEST ItemViewModel Test
    
    func testItemViewModelDiscount() {
        let viewModel = ItemViewModel()
        XCTAssertEqual(15,viewModel.findDiscount(amount: 50001))
        XCTAssertEqual(10,viewModel.findDiscount(amount: 49999))
        XCTAssertEqual(10,viewModel.findDiscount(amount: 50000))
        
        XCTAssertEqual(7,viewModel.findDiscount(amount: 10000))
        XCTAssertEqual(7,viewModel.findDiscount(amount: 7001))

        XCTAssertEqual(5,viewModel.findDiscount(amount: 7000))
        XCTAssertEqual(5,viewModel.findDiscount(amount: 5001))

        XCTAssertEqual(3,viewModel.findDiscount(amount: 1001))
        XCTAssertEqual(3,viewModel.findDiscount(amount: 5000))

        XCTAssertEqual(0,viewModel.findDiscount(amount: 1000))
        XCTAssertEqual(0,viewModel.findDiscount(amount: 999))
        
    }
    
    // TEST INVOICE

    func testItemViewModelInvoice() {
        let viewModel = ItemViewModel()
        do {
            try viewModel.addItem(name: "name", quantity: "1000", unitPrice: "1000", state: TaxFactory.getStates().first!)
            XCTAssertEqual(viewModel.getItems()?.count, 1)
        }
        catch ItemError.parseError(let message) {
            XCTAssertNil(message)
        }
        catch {
        }
        XCTAssertEqual(922250.00, viewModel.getInvoice(state: TaxFactory.getStates().first!)?.totalPrice)
    }
    
    func testItemViewModelInvalidInput() {
        let viewModel = ItemViewModel()
        do {
            try viewModel.addItem(name: "name", quantity: "1", unitPrice: "1", state: TaxFactory.getStates().first!)
            XCTAssertEqual(viewModel.getItems()?.count, 1)
        }
        catch ItemError.parseError(let message) {
            XCTAssertNil(message)
        }
        catch {
        }
        
        viewModel.removeItemAtIndex(index: 0)
        XCTAssertEqual(viewModel.getItems()?.count, 0)
        
        // TEST INVALID INPUT
        do {
            try viewModel.addItem(name: "name", quantity: "ee", unitPrice: "1", state: TaxFactory.getStates().first!)
            XCTAssertEqual(viewModel.getItems()?.count, 1)
        }
        catch ItemError.parseError(let message) {
            XCTAssertEqual("Invalid Quanity",message)
        }
        catch {
            
        }
    
        do {
            try viewModel.addItem(name: "name", quantity: "1", unitPrice: "wer", state: TaxFactory.getStates().first!)
            XCTAssertEqual(viewModel.getItems()?.count, 1)
        }
        catch ItemError.parseError(let message) {
            XCTAssertEqual("Invalid unit price",message)
        }
        catch {
            
        }
    }
    
    //MARK: TEST ViewController
    
    func testViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let billingVC  = storyboard.instantiateViewController(withIdentifier: "BillingVC") as! ViewController
        UIApplication.shared.keyWindow?.addSubview(billingVC.view)
        XCTAssertNotNil(billingVC)
        XCTAssertNotNil(billingVC.tableView)
        XCTAssertNotNil(billingVC.tableView.dataSource)
        XCTAssertNotNil(billingVC.tableView.delegate)
        
        do {
            try billingVC.itemViewModel.addItem(name: "Item", quantity: "1", unitPrice: "1", state: TaxFactory.getStates().first!)
        }
        catch ItemError.parseError(let message) {
            print(message)
        }
        catch {
        }
        billingVC.tableView.reloadData()
        let cell =  billingVC.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ItemCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.item?.itemName, "Item")
        XCTAssertEqual(cell.item?.quantity, 1)
        XCTAssertEqual(cell.item?.unitPrice, 1)

        let footer = billingVC.tableView.footerView(forSection: 0) as! InvoiceView
        footer.invoice = billingVC.itemViewModel.getInvoice(state: TaxFactory.getStates().first!)
        XCTAssertNotNil(footer)
        XCTAssertEqual(footer.lblDiscountAmount.text, "0.00")
        XCTAssertEqual(footer.lblTotalPrice.text, "1.08")
        XCTAssertEqual(footer.lblTotalWithoutTax.text, "1.00")
        
        cell.didTapRemove(UIButton())
        XCTAssertEqual(billingVC.itemViewModel.getItems()?.count, 0)

    }
}

//MARK: TEST StateSelectionViewController delegate

class TestStateSelectionDelegate: StateSelectionDelegate {
    func didSelectState(sender: StateSelectionViewController, state: State) {
        XCTAssertNotNil(sender)
        XCTAssertNotNil(state)
    }
}

