//
//  Species.swift
//  RestApiApp
//
//  Created by Nele Müller on 09.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import UIKit
import Alamofire

struct Species: Codable {
    
    // MARK: - Properties
    
    var name: String?
    var classification: String?
    var designation: String?
    var averageHeight: Int?
    var skinColors: String?
    var hairColors: String?
    var eyeColors: String?
    var averageLifespan: String?
    var homeworld: String?
    var language: String?
    var people: [String]?
    var films: [String]?
    var created: Date?
    var edited: Date?
    var url: String?
}

// MARK: - Initialization from Decoder

extension Species {
    init(from decoder: Decoder) throws {
        let wrapperContainer = try decoder.container(keyedBy: SpeciesField.self)
        
        // String Properties
        
        try self.name = wrapperContainer.decode(String?.self, forKey: .Name)
        try self.classification = wrapperContainer.decode(String?.self, forKey: .Classification)
        
        // below properties are actually not needed yet
        try self.designation = wrapperContainer.decodeIfPresent(String.self, forKey: .Designation)
        try self.skinColors = wrapperContainer.decodeIfPresent(String.self, forKey: .SkinColors)
        try self.hairColors = wrapperContainer.decodeIfPresent(String.self, forKey: .HairColors)
        try self.eyeColors = wrapperContainer.decodeIfPresent(String.self, forKey: .EyeColors)
        try self.averageLifespan = wrapperContainer.decodeIfPresent(String.self, forKey: .AverageLifespan)
        try self.homeworld = wrapperContainer.decodeIfPresent(String.self, forKey: .Homeworld)
        try self.language = wrapperContainer.decodeIfPresent(String.self, forKey: .Language)
        try self.url = wrapperContainer.decodeIfPresent(String.self, forKey: .Url)
        
        // Non-String Properties
        
        let averageHeightAsString = try wrapperContainer.decodeIfPresent(String.self, forKey: .AverageHeight)
        self.averageHeight = anyTypeFromOptionalString(optional: averageHeightAsString)

        let createdAsString = try wrapperContainer.decodeIfPresent(String.self, forKey: .Created)
        self.created = anyTypeFromOptionalString(optional: createdAsString)
        
        let editedAsString = try wrapperContainer.decodeIfPresent(String.self, forKey: .Edited)
        self.edited = anyTypeFromOptionalString(optional: editedAsString)
        
        // Array Properties
        
        var allPeople: [String]? = []
        if wrapperContainer.contains(.People){
            var peopleContainer = try wrapperContainer.nestedUnkeyedContainer(forKey: .People)
            while !peopleContainer.isAtEnd {
                allPeople?.append(try peopleContainer.decode(String.self))
            }
        }
        people = allPeople
        
        var allFilms: [String]? = []
        if wrapperContainer.contains(.Films){
            var filmContainer = try wrapperContainer.nestedUnkeyedContainer(forKey: .Films)
            while !filmContainer.isAtEnd {
                allFilms?.append(try filmContainer.decode(String.self))
            }
            
        }
        films = allFilms
    }
}

// MARK: - Private Methods

extension Species {
    private func intFromOptionalString(optional: String?) -> Int? {
        var returnValue: Int? = nil

        if let value = optional {
            returnValue = Int(value)
        }
       
        return returnValue
    }
    
    private func dateFromOptionalString(optional: String?) -> Date? {
        var returnValue: Date? = nil
        
        if let value = optional {
            returnValue = Date.fromString(date: value)
        }
        
        return returnValue
    }
    
    private func anyTypeFromOptionalString<T>(optional: String?) -> T? {
        guard let value = optional else {
            return nil
        }
        
        switch T.self {
        case is Int.Type:
            return Int(value) as? T
        case is Date.Type:
            return Date.fromString(date: value) as? T
        default:
            print("Could not create object of type \(T.self) from \(String?.self).")
            return nil
        }
    }
}

// MARK: - Enums

enum SpeciesField: String, CodingKey {
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
