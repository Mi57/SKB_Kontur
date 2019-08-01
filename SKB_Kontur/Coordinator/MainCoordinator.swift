//
//  MainCoordinator.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        
        let vc = ContactListTableViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func showDetailsForContact(_ contact: ContactRealmObject?){
        
        let vc = ContactDetailsTableViewController.instantiate()
        vc.coordinator = self
        vc.contact = contact
        navigationController.pushViewController(vc, animated: true)
    }
    
}
