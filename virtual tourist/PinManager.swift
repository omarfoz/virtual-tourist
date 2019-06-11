//
//  PinManager.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 6/9/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation

class PinManager {
    
    class func getNewPin(latitude: Double, longitude: Double) -> Pin {
        
        let pin = Pin(context: DataController.shared.viewContext)
        pin.createdAt = Date()
        pin.latitude = latitude
        pin.longitude = longitude
        DataController.shared.saveContext()
        return pin
    }
    
    class func deletePin(pin:Pin){
        DataController.shared.viewContext.delete(pin)
        DataController.shared.saveContext()

    }
}
