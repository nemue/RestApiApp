//
//  Networking.swift
//  RestApiApp
//
//  Created by Nele Müller on 08.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import Foundation
import Alamofire

protocol Networking {
    func request(url: URL, completionHandler: @escaping (NetworkingResult<NSData?>) -> Void)
    func stringToUrl(string: String) -> URL?
}

struct AlamofireNetworking: Networking {
    func request(url: URL, completionHandler: @escaping (NetworkingResult<NSData?>) -> Void) {
        Alamofire.request(url)
            .responseData{ data in
            if let error = data.result.error {
                completionHandler(NetworkingResult.failure(error))
                return
            }
            guard let resultData = data.data as NSData? else {
                completionHandler(NetworkingResult.failure(BackendError.urlError(reason: "Data couldn't be cast to NSData.")))
                return
            }
            completionHandler(NetworkingResult.success(resultData))
        }
    }
    
    func stringToUrl(string: String) -> URL? {

        guard let httpsUrl = URL.makeHttpsUrlFromString(path: string) else {
            let error = BackendError.urlError(reason: "Tried to load an invalid URL")
            print(error)
            return nil
        }
        
        return httpsUrl
    }
    
}

class MockNetworking: Networking {
    
    let name = "MockSpeciesWrapper"
    
    func request(url: URL, completionHandler: @escaping (NetworkingResult<NSData?>) -> Void) {
        var data: Data
        
        do {
            data = try Data(contentsOf: url)
            let resultData = data as NSData?
            let result = NetworkingResult.success(resultData)
            completionHandler(result)
        }
        catch {
            print(error)
        }
    }
    
    func stringToUrl(string: String) -> URL? {
        let bundle = Bundle(for: type(of: self))
        
        guard let fileUrl = bundle.url(forResource: string, withExtension: "json") else {
            print("JSON file not found.")
            return nil
        }
        
        return fileUrl
    }
    
}

public enum NetworkingResult<Value> {
    case success(Value)
    case failure(Error)
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
