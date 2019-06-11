//
//  VTCollectionViewCell.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 5/27/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation
import UIKit

class VTCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vTViewImage: UIImageView!
    @IBOutlet weak var activityIdicator: UIActivityIndicatorView!
    
   
    func setCell(img : String, pin: Pin){
            activityIdicator.isHidden = false
            activityIdicator.startAnimating()
            vTViewImage.downloaded(from: img, pin: pin) {
                self.activityIdicator.stopAnimating()
                self.activityIdicator.isHidden = true
                
            }
    
        }
    
    func setCellFromDB(image:UIImage) {
        vTViewImage.image = image
    }
    
    
        
    }


