//
//  Constants.swift
//  RestApiApp
//
//  Created by Nele Müller on 24.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Endpoints {
        static let speciesEndpoint = "https://swapi.co/api/species/"
    }
    
    struct SpeciesViewConstants {
        static let speciesCellIdentifier = "SpeciesTableCellIdentifier"
    }
    
    struct ColorConstants {
        static let veryLightGrey = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        static let white = UIColor.white
    }
}
