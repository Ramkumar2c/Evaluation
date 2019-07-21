//
//  StateSelectionViewController.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/19/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import UIKit

protocol StateSelectionDelegate {
    func didSelectState(sender: StateSelectionViewController, state: State)
}

class StateSelectionViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var states = TaxFactory.getStates()
    var delegate: StateSelectionDelegate?
    
    //MARK: ViewController life cycle

     override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Custom actions
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource

extension StateSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let state = states[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = DecimalFormatter.sharedFormatter.string(from: state.tax)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectState(sender: self, state: states[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
