//
//  Coordinator.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    
    func start()
}

protocol Storyboarded {
    static func instantiate()->Self
}

extension Storyboarded where Self: UIViewController{
    
    static func instantiate()->Self{
        let id = String(describing: self)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)
        
        return viewController as! Self
    }
}
