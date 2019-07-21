//
//  ViewController.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/17/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtItem: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtUnitPrice: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet var toolBar: UIToolbar!
    
    private let footerIdentifier = "InvoiceFooterId"
    let itemViewModel: ItemViewModel = ItemViewModel()
    
    //MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtQuantity.inputAccessoryView = toolBar
        txtUnitPrice.inputAccessoryView = toolBar
        txtState.inputView = nil
        tableView.register(UINib(nibName: "InvoiceView", bundle: nil), forHeaderFooterViewReuseIdentifier: footerIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StateSelection" {
            let stateSelectionVC = segue.destination as? StateSelectionViewController
            stateSelectionVC?.delegate = self
        }
    }
    
    //MARK: Custom actions
    @IBAction func didTapAdd(_ sender: UIButton) {
        guard let name = txtItem.text, let quanity = txtQuantity.text, let unitPrice = txtUnitPrice.text, let stateTxt = txtState.text, let state = TaxFactory.getStateByName(name: stateTxt) else {
            return
        }
        if Util.validateInput(name: name, quantity: quanity, price: unitPrice, state: state) {
            do {
                try itemViewModel.addItem(name: name, quantity: quanity, unitPrice: unitPrice, state: state)
                let count = itemViewModel.getItems()?.count ?? 0
                tableView.performBatchUpdates({ [weak self] in
                    self?.tableView.insertRows(at: [IndexPath.init(row: count - 1, section: 0)], with: .bottom)
                    self?.reloadFooter()
                }) { [weak self] (success) in
                    self?.tableView.scrollToRow(at: IndexPath.init(row: count - 1, section: 0), at: .bottom, animated: true)
                }
                resetTxtFlds()
            }
            catch ItemError.parseError(let message) {
                showAlert(message: message)
            }
            catch {
                showAlert(message: "Something went wrong")
            }
        }
        else {
            showAlert(message: "All fields are mandatory")
        }
    }
    
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    //MARK: Utility Methods
    private func resetTxtFlds() {
        txtItem.text = ""
        txtQuantity.text = ""
        txtUnitPrice.text = ""
        self.view.endEditing(true)
    }
    
    private func reloadFooter() {
        guard let footer = tableView.footerView(forSection: 0) as? InvoiceView else {
            return
        }
        if let stateTxt = txtState.text, let state = TaxFactory.getStateByName(name: stateTxt) {
            footer.invoice = itemViewModel.getInvoice(state: state)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = itemViewModel.getItems() {
          return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.item = nil // Cleaning up UI
        if let items = itemViewModel.getItems() {
            cell.item = items[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerIdentifier) as? InvoiceView else {
            return UIView()
        }
        if let stateTxt = txtState.text, let state = TaxFactory.getStateByName(name: stateTxt) {
            footer.invoice = itemViewModel.getInvoice(state: state)
        }
        return footer
    }
}

//MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtState {
            performSegue(withIdentifier: "StateSelection", sender: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtQuantity  {
            return Util.limitCharacters(textField.text ?? "", inRange: range, replacementString: string, limitBy: 5)
        }
        else if textField == txtUnitPrice {
            return Util.validateDecimal(textField.text ?? "", inRange: range, replacementString: string)
        }
        return true
    }
}

//MARK: ItemCellDelegate
extension ViewController: ItemCellDelegate {
    func didTapRemove(sender: ItemCell, item: Item) {
        if let indexPath = tableView.indexPath(for: sender) {
            do {
                try itemViewModel.removeItemAtIndex(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                reloadFooter()
            }
            catch ItemError.parseError(let message) {
                showAlert(message: message)
            }
            catch {
                showAlert(message: "Something went wrong")
            }

        }
    }
}

//MARK: StateSelectionDelegate
extension ViewController: StateSelectionDelegate {
    func didSelectState(sender: StateSelectionViewController, state: State) {
        txtState.text = state.name
    }
}
