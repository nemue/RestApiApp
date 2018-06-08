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
    
    // MARK: - Access Methods
    
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
                                        completionHandler: @escaping (Result<SpeciesWrapper>) -> Void, useAlamofire: Bool? = true) {

        guard let url = makeUrlHttps(path: path) else {
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
            let speciesWrapperResult: Result<SpeciesWrapper> = self.parseJSON(response.result)
            completionHandler(speciesWrapperResult)
        }
    }
    
    // MARK: - Serialisation
    
    class func parseJSON<T: Codable>(_ result: Result<Data>) -> Result<T>{
        guard result.error == nil else {
            print(result.error!)
            return Result.failure(result.error!)
        }

        guard let json = result.value else {
            print("Didn't get species object as JSON from API")
            return Result.failure(BackendError.objectSerialization(reason: "Did not get JSON dictionary in response"))
        }
        
        let decoder = JSONDecoder()
        var wrapper: T? = nil
        do {
            wrapper = try decoder.decode(T.self, from: json)
        }
        catch {
            print("Error decoding JSON: \(error)")
        }
        
        return Result.success(wrapper!) // wrapper can't be nil after try/catch
    }
    
    // MARK: - Helper Methods
    
    class func makeUrlHttps(path: String) -> URL?{
        guard var urlComponents = URLComponents(string: path) else {
            return nil
        }
        urlComponents.scheme = "https"
        
        guard let url = try? urlComponents.asURL() else {
            return nil
        }
        
        return url
    }
}

// MARK: - Error Enum

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}
