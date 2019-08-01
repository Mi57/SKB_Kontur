//
//  Extensions.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

extension String {
    
    func convertFromStringToDate() -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func toNormalPhoneNumber() -> String{
        return self.filter{$0.wholeNumberValue != nil}
    }
}
