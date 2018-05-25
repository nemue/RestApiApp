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
        
        try name = wrapperContainer.decode(String?.self, forKey: .Name)
        try classification = wrapperContainer.decode(String?.self, forKey: .Classification)
        
        // below properties are actually not needed yet
        try designation = wrapperContainer.decode(String?.self, forKey: .Designation)
        try averageHeight = Int(wrapperContainer.decode(String?.self, forKey: .AverageHeight)!)
        try skinColors = wrapperContainer.decode(String?.self, forKey: .SkinColors)
        try hairColors = wrapperContainer.decode(String?.self, forKey: .HairColors)
        try eyeColors = wrapperContainer.decode(String?.self, forKey: .EyeColors)
        try averageLifespan = wrapperContainer.decode(String?.self, forKey: .AverageLifespan)
        try homeworld = wrapperContainer.decode(String?.self, forKey: .Homeworld)
        try language = wrapperContainer.decode(String?.self, forKey: .Language)
        try created = Date.fromString(date: wrapperContainer.decode(String?.self, forKey: .Created)!)
        try edited = Date.fromString(date: wrapperContainer.decode(String?.self, forKey: .Edited)!)
        try url = wrapperContainer.decode(String?.self, forKey: .Url)
        
        var peopleContainer = try wrapperContainer.nestedUnkeyedContainer(forKey: .People)
        var allPeople: [String] = []
        while !peopleContainer.isAtEnd {
            allPeople += [try peopleContainer.decode(String.self)]
        }
        people = allPeople
        
        var filmContainer = try wrapperContainer.nestedUnkeyedContainer(forKey: .Films)
        var allFilms: [String] = []
        while !filmContainer.isAtEnd {
            allFilms += [try filmContainer.decode(String.self)]
        }
        films = allFilms
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
