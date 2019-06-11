//
//  FlickerResponse.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 5/29/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation


struct FlickerResponse: Codable {
    let photos: Photos
    let stat: String
}


struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [FlickerImage]
}

struct FlickerImage: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let urlM: String
    let heightM, widthM: String
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case urlM = "url_m"
        case heightM = "height_m"
        case widthM = "width_m"
    }
}
