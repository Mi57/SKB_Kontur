//
//  ContactRealmObject.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class ContactRealmObject: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var height: Float = 0
    @objc dynamic var biography: String = ""
    @objc dynamic var temperament: String = ""
    @objc dynamic var educationPeriod: EducationPeriodRealmObject?
    
    @objc dynamic var phoneForSearch: String = ""
    override static func primaryKey()-> String?{
        return "id"
    }
}

class EducationPeriodRealmObject: Object {
    
    @objc dynamic var start: String = ""
    @objc dynamic var end: String = ""
}
