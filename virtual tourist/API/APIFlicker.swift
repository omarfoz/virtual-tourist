//
//  APIFlickr.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 5/29/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation


struct APIFlicker {
    static let apiKey = "f451c9a47032bd3587b5126219f8907e"
    static let baseURL = "https://api.flickr.com/services/rest/?method="
    
    struct Parameters {
        static let apiKeyVar = "&api_key="
        static let latitude = "&lat="
        static let longitude = "&lon="
        static let extras = "&extras=url_m"
        static let perPage = "&per_page="
        static let page = "&page="
        static let format = "&format=json"
        static let callBack = "&nojsoncallback=1"
        static let radious = "&radius=10"
    }
    
    enum EndPoints {
        
        case searchPhoto(latitude: Double, longitude: Double, page: Int, perPage: Int)
        
        
        var stringValue: String {
            switch self {
            case let .searchPhoto(latitude, longitude, page, perPage) :
                return "\(APIFlicker.baseURL)flickr.photos.search\(Parameters.apiKeyVar)\(APIFlicker.apiKey)\(Parameters.latitude)\(latitude)\(Parameters.longitude)\(longitude)\(Parameters.extras)\(Parameters.perPage)\(perPage)\(Parameters.radious)\(Parameters.page)\(page)\(Parameters.format)\(Parameters.callBack)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
}


