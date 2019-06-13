//
//  VTCollectionViewCell.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 5/27/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class VTCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vTViewImage: UIImageView!
    @IBOutlet weak var activityIdicator: UIActivityIndicatorView!

    var image: Images! {
        didSet {
            if let image = image.fetchImage() {
                vTViewImage.image = image
            } else if let url = URL(string: image.imageURL!){
                vTViewImage.kf.indicatorType = .activity
                vTViewImage.kf.setImage(with: url, options: [.transition(.fade(0.5))])
            }
        }
    }
 }


extension Images {
    
    func fetchImage() -> UIImage? {
        guard let data = image else { return nil }
        return UIImage(data: data)
    }
}
