//
//  ContactListTableViewController.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import RealmSwift

final class ContactListTableViewController: UITableViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    var startDate: Date {
        return (UserDefaults.standard.value(forKey: "appStartDate") as? Date) ?? Date()
    }
    var isFirstStart: Bool {
        return UserDefaults.standard.bool(forKey: "isFirstStart")
    }
    var refresher: UIRefreshControl!
    private let searchController = UISearchController(searchResultsController: nil)
    var contacts: Results<ContactRealmObject>?{
        didSet{
            tableView.reloadData()
        }
    }
    
    var filteredContacts: Results<ContactRealmObject>?
    
    @objc fileprivate func getContacts() {
        if !refresher.isRefreshing {
            activityIndicator.startAnimating()
        }
        let dateDiff = Date().timeIntervalSince(startDate)
        if !isFirstStart {
            guard dateDiff >= 60 else {
                contacts = RealmHelper.shared.getAllContactsFromRealm()
                activityIndicator.stopAnimating()
                refresher.endRefreshing()
                return
            }
        }
        
        ServerAPI.getContacts { (result) in
            switch result {
            case .success(_ ):
                self.updateStartDate()
                UserDefaults.standard.set(false, forKey: "isFirstStart")
                self.contacts = RealmHelper.shared.getAllContactsFromRealm()
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                self.refresher.endRefreshing()
            case .failure(_ ):
                self.refresher.endRefreshing()
                UIApplication.shared.showErrorLabel(withText: "Нет подключения к сети")
            }
        }
    }
    
    private func updateStartDate(){
        UserDefaults.standard.set(Date(), forKey: "appStartDate")
    }
    
    fileprivate func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        refresher = UIRefreshControl()
        refresher?.attributedTitle = NSAttributedString(string: "Потяните чтобы обновить")
        refresher?.tintColor = .lightGray
        refresher?.addTarget(self, action: #selector(getContacts), for: .valueChanged)
        tableView.addSubview(refresher)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.showsCancelButton = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // The default is true.
        //        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */
        
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true
        
        getContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        refresher.endRefreshing()
    }
    private func refresh(){
        getContacts()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListTableViewCell
        let contact: ContactRealmObject?
        if filteredContacts != nil, !filteredContacts!.isEmpty {
            contact = filteredContacts![indexPath.row]
        } else {
            contact = contacts?[indexPath.row]
        }
        cell.fillWithContact(contact)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredContacts != nil, !filteredContacts!.isEmpty {
            return filteredContacts!.count
        } else {
            return contacts?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedContact = contacts?[indexPath.row]
        coordinator?.showDetailsForContact(selectedContact)
    }
    
}

extension ContactListTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString =  searchController.searchBar.text,
            !searchString.isEmpty else {return}
        let predicate = NSPredicate(format: "name CONTAINS[c] %@ OR phoneForSearch LIKE %@",searchString,  "*" + searchString + "*")
        filteredContacts = contacts?.filter(predicate)
        tableView.reloadData()
    }
    
    
}

extension ContactListTableViewController: UISearchControllerDelegate{
    
}

extension UIApplication {
    
    func showToastMessage(_ message: String,
                          withDuration duration: TimeInterval = 0.3,
                          timeIntervalToHide: TimeInterval = 3,
                          backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5),
                          textColor: UIColor = .white){
        
        let errorLabelTag = 554433
        let labelIdentifier = "error label"
        
        if let view = UIApplication.shared.keyWindow?.viewWithTag(errorLabelTag) {
            if view.restorationIdentifier == labelIdentifier {
                return
            }
        }
        
        DispatchQueue.main.async {
            let label = UILabel(frame: CGRect(x: 32, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 64, height: 44))
            label.backgroundColor = backgroundColor
            label.text = message
            label.textColor = textColor
            label.textAlignment = .center
            label.tag = errorLabelTag
            label.restorationIdentifier = labelIdentifier
            
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            UIApplication.shared.keyWindow?.addSubview(label)
            
            Timer.scheduledTimer(timeInterval: timeIntervalToHide, target: self, selector: #selector(self.hideErrorLabel), userInfo: nil, repeats: false)
            
            UIView.animate(withDuration: duration) {
                label.frame.origin.y -= label.frame.height * 3
                UIApplication.shared.keyWindow?.layoutIfNeeded()
            }
        }
    }
    
    func showErrorLabel(withText text: String) {
        showToastMessage(text)
    }
    
    
    @objc private func hideErrorLabel () {
        let errorLabelTag = 554433
        let labelIdentifier = "error label"
        
        if let errorLabel = UIApplication.shared.keyWindow?.viewWithTag(errorLabelTag) {
            if errorLabel.restorationIdentifier != labelIdentifier {
                return
            }
            
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    errorLabel.frame.origin.y = UIScreen.main.bounds.height
                }) { done in
                    errorLabel.removeFromSuperview()
                }
            }
        }
    }
    
    
    
    
    
    
}
