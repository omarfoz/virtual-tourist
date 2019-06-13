//
//  ImageManager.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 6/9/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation
import CoreData


class ImageManager {
    
    class func getNewPhoto(pin: Pin, imageUrl: String) {
        
        let photo = Images(context: DataController.shared.viewContext)
        photo.createdAt = Date()
        photo.imageURL = imageUrl
        photo.pin = pin
    }
    
    class func savePhotos(pin: Pin, images: [FlickerImage]) {
        
        for image in images {
            getNewPhoto(pin: pin, imageUrl: image.urlM)
        }
        DataController.shared.saveContext()
    }
    
    class func deletePhotos(photos: [Images]) {
        for photo in photos {
            deletePhoto(photo: photo)
        }
        DataController.shared.saveContext()
    }
    
    class func deletePhoto(photo: Images) {
        DataController.shared.viewContext.delete(photo)
    }
    
    
    
}
