//
//  Species.swift
//  RestApiApp
//
//  Created by Nele Müller on 09.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import UIKit
import Alamofire

class Species {
    
    // MARK: - Properties
    
    var idNumber: Int?
    var name: String?
    var classification: String?
    var designation: String?
    var averageHeight: Int?
    var skinColors: [String]?
    var hairColors: [String]?
    var eyeColors: [String]?
    var averageLifespan: String?
    var homeworld: String?
    var language: String?
    var people: [String]?
    var films: [String]?
    var created: Date?
    var edited: Date?
    var url: String?
    
    // MARK: - Initialization
    
    required init(json: [String: Any]) {
        self.name = json[SpeciesField.Name.rawValue] as? String
        self.classification = json[SpeciesField.Classification.rawValue] as? String
        self.designation = json[SpeciesField.Designation.rawValue] as? String
        self.averageHeight = json[SpeciesField.AverageHeight.rawValue] as? Int
    }
    
    // MARK: - API Endpoint
    
    class func endpointForSpecies() -> String {
        return "https://swapi.co/api/species/"
    }
    
    // MARK: - Private Static Methods
    
    private class func speciesArrayFromResponse(_ response: DataResponse<Any>) -> Result<SpeciesWrapper>{
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
            let speciesWrapperResult = Species.speciesArrayFromResponse(response)
            completionHandler(speciesWrapperResult)
        }
    }
    
    // MARK: - Internal Static Methods
    
    class func getFirstSpeciesWrapper(completionHandler: @escaping (Result<SpeciesWrapper>) -> Void){
        let endpoint = self.endpointForSpecies()
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
}

// MARK: - Enums

enum SpeciesField: String {
    case Name = "name"
    case Classification = "classification"
    case Designation = "designation"
    case AverageHeight = "average_height"
    case SkinColors = "skin_colors"
    case HairColors = "hair_colors"
    case EyeColors = "eye_colors"
    case AverageLifespan = "average_lifespan"
    case Homeworld = "homeworld"
    case Language = "language"
    case People = "people"
    case Films = "films"
    case Created = "created"
    case Edited = "edited"
    case Url = "url"
}

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

