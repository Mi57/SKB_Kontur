//
//  Constants.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
struct Constants {
    
    static let URL_BASE = "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/"
    
    static let getFirstJson = "generated-01.json"
    static let getSecondJson = "generated-02.json"
    static let getThirdJson =  "generated-03.json"
    
    static var linksToDownloadFrom: [String] {
        return [getFirstJson, getSecondJson, getThirdJson]
    }
}
