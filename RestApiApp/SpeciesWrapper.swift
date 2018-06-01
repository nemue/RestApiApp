//
//  SpeciesWrapper.swift
//  RestApiApp
//
//  Created by Nele Müller on 09.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import UIKit

struct SpeciesWrapper: Codable {
    var species: [Species]?
    var count: Int?
    var next: String?
    var previous: String?
}

// MARK: - Initialization from Decoder

extension SpeciesWrapper {
    init (from decoder: Decoder) throws {
        let speciesContainer = try decoder.container(keyedBy: SpeciesWrapperCodingKeys.self)
        
        var resultsSpecies: [Species]? = []
        if speciesContainer.contains(.Species) {
            var results = try speciesContainer.nestedUnkeyedContainer(forKey: .Species)
            while !results.isAtEnd {
                resultsSpecies?.append(try results.decode(Species.self))
            }
        }
        species = resultsSpecies
        
        try count = speciesContainer.decodeIfPresent(Int.self, forKey: .Count)
        try next = speciesContainer.decodeIfPresent(String.self, forKey: .Next)
        try previous = speciesContainer.decodeIfPresent(String.self, forKey: .Previous)
    }
}

// MARK: - Enums

enum SpeciesWrapperCodingKeys: String, CodingKey {
    case Species = "results"
    case Count = "count"
    case Next = "next"
    case Previous = "previous"
}
