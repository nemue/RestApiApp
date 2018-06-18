//
//  NetworkManager.swift
//  RestApiApp
//
//  Created by Nele Müller on 24.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    var networking: Networking
    var endpoint: String
    
    init(networking: Networking = AlamofireNetworking(), endpoint: String = Constants.Endpoints.speciesEndpoint) {
        self.networking = networking
        self.endpoint = endpoint
    }
    
    // MARK: - Access Methods
    
    func getFirstSpeciesWrapper(completionHandler: @escaping (NetworkingResult<SpeciesWrapper>) -> Void){
        getSpeciesAtPath(self.endpoint, completionHandler: completionHandler)
    }
    
    func getNextSpeciesWrapper(_ wrapper: SpeciesWrapper?,
                                     completionHandler: @escaping (NetworkingResult<SpeciesWrapper>) -> Void) {
        guard let nextUrl = wrapper?.next else {
            let error = BackendError.objectSerialization(reason: "Did not get wrapper for more species")
            completionHandler(NetworkingResult.failure(error))
            return
        }
        getSpeciesAtPath(nextUrl, completionHandler: completionHandler)
    }
    
    // MARK: - Network Requests
    
    private func getSpeciesAtPath(_ path: String,
                                        completionHandler: @escaping (NetworkingResult<SpeciesWrapper>) -> Void, useAlamofire: Bool? = true) {

        guard let httpsUrl = self.networking.stringToUrl(string: path) else {
            let error = BackendError.urlError(reason: "Tried to load an invalid URL")
            completionHandler(NetworkingResult.failure(error))
            return
        }
        
        // API request:
        
        let _ = networking.request(url: httpsUrl) { response in
            guard let data = response.value as? NSData else {
                print("Response value couldn't be saved as NSData")
                return
            }
            let speciesWrapperResult: NetworkingResult<SpeciesWrapper> = self.parseJSON(data)
            completionHandler(speciesWrapperResult)
        }
    }
    
    // MARK: - Serialisation
    
    func parseJSON<T: Codable>(_ result: NSData) -> NetworkingResult<T>{
        let json = result as Data
        let decoder = JSONDecoder()
        var wrapper: T? = nil
        do {
            wrapper = try decoder.decode(T.self, from: json)
        }
        catch {
            print("Error decoding JSON: \(error)")
        }
        guard let successWrapper = wrapper else {
            return NetworkingResult.failure(BackendError.objectSerialization(reason: "Optional wrapper could not be unwrapped."))
        }
        
        return NetworkingResult.success(successWrapper)
    }
}

// MARK: - Error Enum

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}
