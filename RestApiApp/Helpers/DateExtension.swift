//
//  DateExtension.swift
//  RestApiApp
//
//  Created by Nele Müller on 25.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import Foundation

extension Date {
    static func fromString(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let returnDate = dateFormatter.date(from: date) else {
            return nil
        }
        
        return returnDate
    }
}
