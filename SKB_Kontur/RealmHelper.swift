//
//  RealmHelper.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmHelper {
    
    static let shared = RealmHelper()
    private init(){}
    
    func getRealm()->Realm{
        let realm = try! Realm()
        return realm
    }
    
    func saveContactsToRealm(_ contacts: [Contact]){
        
        let realm = getRealm()
        try! realm.write {
            
            for contact in contacts {
                let contactForRealm = ContactRealmObject()
                contactForRealm.id = contact.id
                contactForRealm.name = contact.name
                contactForRealm.phone = contact.phone
                contactForRealm.height = contact.height
                contactForRealm.phoneForSearch = contact.phone.toNormalPhoneNumber()
                contactForRealm.biography = contact.biography
                contactForRealm.temperament = contact.temperament.description
                
                let educationPeriodRealmObject = EducationPeriodRealmObject()
                educationPeriodRealmObject.start = contact.educationPeriod.start
                educationPeriodRealmObject.end = contact.educationPeriod.end
                contactForRealm.educationPeriod = educationPeriodRealmObject
                
                realm.add(contactForRealm, update: .modified)
            }
        }
    }
    
    func getAllContactsFromRealm()->Results<ContactRealmObject>{
        let realm = getRealm()
        let contactsFromRealm = realm.objects(ContactRealmObject.self)
        return contactsFromRealm
    }
    
}

