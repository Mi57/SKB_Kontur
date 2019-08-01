//
//  ServerAPI.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

enum RequestError: Error{
    case unreachable
}

final class ServerAPI {
    static var operationCount = 0
    static func getContacts(complete: @escaping (Result<Bool,Error>)->Void){
        
        let arrayOfJsonLinks = Constants.linksToDownloadFrom
        for linkToDownloadFrom in arrayOfJsonLinks{
            ServerClient.GET(linkToDownloadFrom) { answer in
                switch answer {
                case .success(let jsonFromServer):
                    //                    let arrayOfContscts = jsonFromServer.arrayValue
                    let contacts = Contact.initFromJson(jsonFromServer)
                    let rh = RealmHelper.shared
                    rh.saveContactsToRealm(contacts)
                    operationCount += 1
                    if operationCount == arrayOfJsonLinks.count {
                        operationCount = 0
                        complete(Result.success(true))
                    }
                case .error(_ ):
                    complete(Result.failure(RequestError.unreachable))
                }
            }
        }
    }
}
