//
//  Contact.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Contact{
    
    struct EducationPeriod {
        let start: String
        let end: String
    }
    
    enum Temperament: String, CustomStringConvertible{
        
        case melancholic = "melancholic"
        case phlegmatic = "phlegmatic"
        case sanguine = "sanguine"
        case choleric = "choleric"
        case unknown = ""
        
        var description: String{
            switch self {
            case .melancholic:
                return "Melancholic"
            case .phlegmatic:
                return "Phlegmatic"
            case .sanguine:
                return "Sanguine"
            case .choleric:
                return "Choleric"
            case .unknown:
                return ""
            }
        }
    }
    
    let id: String
    let name: String
    let height: Float
    let phone: String
    let biography: String
    let temperament: Temperament
    let educationPeriod: EducationPeriod
    
    static func initFromJson(_ json:JSON)->[Contact]{
        
        var contacts: [Contact] = []
        let jsonContactArray = json.arrayValue
        
        for jsonContact in jsonContactArray {
            
            let educationPeriod = EducationPeriod(start: jsonContact["educationPeriod"]["start"].stringValue,
                                                  end: jsonContact["educationPeriod"]["end"].stringValue)
            
            let newContact = Contact(id: jsonContact["id"].string ?? UUID().uuidString,
                                     name: jsonContact["name"].stringValue,
                                     height: jsonContact["height"].floatValue,
                                     phone: jsonContact["phone"].stringValue,
                                     biography: jsonContact["biography"].stringValue,
                                     temperament: Temperament(rawValue: jsonContact["temperament"].stringValue) ?? Temperament.unknown,
                                     educationPeriod: educationPeriod)
            contacts.append(newContact)
        }
        
        return contacts
    }
}
