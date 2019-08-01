//
//  ServerClient.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ServerResponseResult {
    case success(_: JSON)
    case error(_: String)
}

final class ServerClient {
    
    static func GET(_ relativeUrl: String, complete: @escaping (_ : ServerResponseResult) -> Void) {
        ServerClient.GET(relativeUrl, customHeaders: nil, parameters: [:], complete: complete)
    }
    
    static func GET(_ relativeUrl: String, customHeaders: [String:String]?, parameters: [String: AnyObject], complete: @escaping (_ : ServerResponseResult) -> Void) {
        var url = Constants.URL_BASE + relativeUrl
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            url = encodedURL
        }
        
        Alamofire.request(url, encoding: JSONEncoding.prettyPrinted, headers: customHeaders)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    
                    let errorDto = json["errorDTO"]
                    if errorDto.exists() && errorDto["message"].exists() {
                        let message = errorDto["message"].stringValue
                        debugPrint("response GET ERROR: \(message)")
                        complete(ServerResponseResult.error(message))
                    } else {
                        complete(ServerResponseResult.success(json))
                    }
                case .failure(let e):
                    complete(ServerResponseResult.error(""))
                }
        }
    }
}
