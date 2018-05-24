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
    
    // MARK: - Internal static methods
    
    class func getFirstSpeciesWrapper(completionHandler: @escaping (Result<SpeciesWrapper>) -> Void){
        let endpoint = Constants.Endpoints.speciesEndpoint
        getSpeciesAtPath(endpoint, completionHandler: completionHandler)
    }
    
    class func getNextSpeciesWrapper(_ wrapper: SpeciesWrapper?, completionHandler: @escaping (Result<SpeciesWrapper>) -> Void) {
        guard let nextUrl = wrapper?.next else {
            let error = BackendError.objectSerialization(reason: "Did not get wrapper for more species")
            completionHandler(Result.failure(error))
            return
        }
        getSpeciesAtPath(nextUrl, completionHandler: completionHandler)
    }
    
    // MARK: - private static methods
    
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
        let _ = Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                completionHandler(Result.failure(error))
                return
            }
            let speciesWrapperResult = self.parseJSON(response)
            completionHandler(speciesWrapperResult)
        }
    }
    
    private class func parseJSON(_ response: DataResponse<Any>) -> Result<SpeciesWrapper>{
        guard response.result.error == nil else {
            print(response.result.error!)
            return Result.failure(response.result.error!)
        }
        
        guard let json = response.result.value as? [String: Any] else {
            print("Didn't get species object as JSON from API")
            return Result.failure(BackendError.objectSerialization(reason: "Did not get JSON dictionary in response"))
        }
        
        let wrapper = SpeciesWrapper()
        wrapper.next = json["next"] as? String
        wrapper.previous = json["previous"] as? String
        wrapper.count = json["count"] as? Int
        
        var allSpecies: [Species] = []
        if let results = json["results"] as? [[String: Any]] {
            for jsonSpecies in results {
                let species = Species(json: jsonSpecies)
                allSpecies.append(species)
            }
        }
        
        wrapper.species = allSpecies
        return Result.success(wrapper)
    }
    
    
    
    
}
