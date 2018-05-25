//
//  NetworkManager.swift
//  RestApiApp
//
//  Created by Nele Müller on 24.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // MARK: - Internal Static Methods
    
    class func getFirstSpeciesWrapper(completionHandler: @escaping (Result<SpeciesWrapper>) -> Void){
        let endpoint = Constants.Endpoints.speciesEndpoint
        getSpeciesAtPath(endpoint, completionHandler: completionHandler)
    }
    
    class func getNextSpeciesWrapper(_ wrapper: SpeciesWrapper?,
                                     completionHandler: @escaping (Result<SpeciesWrapper>) -> Void) {
        guard let nextUrl = wrapper?.next else {
            let error = BackendError.objectSerialization(reason: "Did not get wrapper for more species")
            completionHandler(Result.failure(error))
            return
        }
        getSpeciesAtPath(nextUrl, completionHandler: completionHandler)
    }
    
    // MARK: - Network Requests
    
    private class func getSpeciesAtPath(_ path: String,
                                        completionHandler: @escaping (Result<SpeciesWrapper>) -> Void) {
        // URL must be https:
        guard var urlComponents = URLComponents(string: path) else {
            let error = BackendError.urlError(reason: "Tried to load an invalid URL")
            completionHandler(Result.failure(error))
            return
        }
        urlComponents.scheme = "https"
        
        guard let url = try? urlComponents.asURL() else {
            let error = BackendError.urlError(reason: "Tried to load an invalid URL")
            completionHandler(Result.failure(error))
            return
        }
        
        // API request:
        let _ = Alamofire.request(url).responseData { response in
            if let error = response.result.error {
                completionHandler(Result.failure(error))
                return
            }
            let speciesWrapperResult = self.parseJSON(response)
            completionHandler(speciesWrapperResult)
        }
    }
    
    // MARK: - Serialisation
    
    private class func parseJSON(_ response: DataResponse<Data>) -> Result<SpeciesWrapper>{
        guard response.result.error == nil else {
            print(response.result.error!)
            return Result.failure(response.result.error!)
        }

        guard let json = response.result.value else {
            print("Didn't get species object as JSON from API")
            return Result.failure(BackendError.objectSerialization(reason: "Did not get JSON dictionary in response"))
        }
        
        let decoder = JSONDecoder()
        var wrapper = SpeciesWrapper()
        do {
            wrapper = try decoder.decode(SpeciesWrapper.self, from: json)
        }
        catch {
            print("Error decoding JSON: \(error)")
        }
        
        return Result.success(wrapper)
    }
}

// MARK: - Error Enum

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}
