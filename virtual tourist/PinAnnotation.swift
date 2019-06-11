//
//  PinAnnotation.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 6/10/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: MKPointAnnotation{
    
    var pinObject: Pin!
    
    init(pin: Pin){
        super.init()
        self.pinObject = pin
        coordinate.latitude = pin.latitude
        coordinate.longitude = pin.longitude
    }
    
    override init() {
        super.init()
    }
}

