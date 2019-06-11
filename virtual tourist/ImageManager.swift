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
    
    
    class func getNewImage(pin: Pin, imageUrl: String, imageData: Data) {
        
        let image = Images(context: DataController.shared.viewContext)
        image.createdAt = Date()
        image.imageURL = imageUrl
        image.image = imageData
        image.pin = pin
    }
    
    
    class func saveImage(pin: Pin, imageUrl: String, imageData: Data) {
        
       
       getNewImage(pin: pin, imageUrl: imageUrl,imageData: imageData)
    
        DataController.shared.saveContext()
    }
    
    class func deleteImages(pin: Pin) {
       for image in pin.images! as! Set<Images> {
            deleteImage(image: image)
        }
        DataController.shared.saveContext()
    }
    
    class func deleteImage(image: Images) {
        DataController.shared.viewContext.delete(image)
    }
    
    
    
}
