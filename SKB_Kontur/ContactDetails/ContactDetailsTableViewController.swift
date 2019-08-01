//
//  ContactDetailsTableViewController.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

enum ActionType {
    case phoneCall
}
protocol CellAction: class{
    func performCellActionWithType(_ actionType: ActionType)
}

final class ContactDetailsTableViewController: UITableViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    var contact: ContactRealmObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contact != nil ? 1:0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactDetailsTableViewCell
        cell.delegate = self
        cell.fillWithContact(contact)
        
        
        
        return cell
    }
    
    
}

extension ContactDetailsTableViewController: CellAction{
    func performCellActionWithType(_ actionType: ActionType) {
        
        switch actionType {
        case .phoneCall:
            
            guard let phoneNumber = contact?.phone,
                let urlForPhoneCall = URL(string: "tel://+" + phoneNumber.toNormalPhoneNumber()), UIApplication.shared.canOpenURL(urlForPhoneCall) else {return}
            UIApplication.shared.open(urlForPhoneCall, options: [:], completionHandler: nil)
        }
    }
    
    
    
    
}
