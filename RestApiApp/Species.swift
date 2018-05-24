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
    
    
   
    
    // MARK: - Private Static Methods
    
    
    
    // MARK: - Internal Static Methods
    
    
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

