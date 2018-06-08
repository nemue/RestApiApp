//
//  customResponseProtocol.swift
//  RestApiApp
//
//  Created by Nele Müller on 08.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import Foundation
import Alamofire

protocol customResponseProtocol {
    subscript(key: String, completionHandler: @escaping (DataResponse<Data>) -> Void)
        -> AnyObject? { get }
}

//extension Alamofire.Request: customResponseProtocol {
//    subscript(key: String, completionHandler: @escaping (DataResponse<Data>) -> Void) -> AnyObject? {
//        return Alamofire.request(key).responseData { response in
//            completionHandler(response)
//        }
//    }
//}

