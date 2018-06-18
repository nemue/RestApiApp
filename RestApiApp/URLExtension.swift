//
//  URLExtension.swift
//  RestApiApp
//
//  Created by Nele Müller on 11.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import Foundation

extension URL {
    static func makeHttpsUrlFromString(path: String) -> URL?{
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
