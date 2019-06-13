//
//  FlickrClient.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 5/29/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation
import UIKit
class FlickrClient {
    
    class func searchPhotos(latitude: Double, longitude: Double, done: @escaping ([FlickerImage]) -> Void,  errors: @escaping (Error) -> Void ){
        
        // get Random page between 1...100
        let page = Int.random(in: 1...100)
        
        let url = APIFlicker.EndPoints.searchPhoto(latitude: latitude, longitude: longitude, page: page, perPage: 9).url
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                
                let problemError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "You are not connected"])
                DispatchQueue.main.async {
                    
                    errors(problemError)
                }
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                let flickerResonse = try JSONDecoder().decode(FlickerResponse.self, from: data)
                DispatchQueue.main.async {
                    done(flickerResonse.photos.photo)
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    errors(error)
                }
            }
            
        }
        task.resume()
    }
    
}
