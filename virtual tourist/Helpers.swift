//
//  Alert.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 5/29/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showFailureFromViewController(viewController: UIViewController, message: String) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
    
}



extension UIImageView {
    func downloaded(from url: URL,pin: Pin, contentMode mode: UIView.ContentMode = .scaleAspectFill,done: @escaping ()-> Void) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
             ImageManager.saveImage(pin: pin, imageUrl: url.absoluteString, imageData: data)
            DispatchQueue.main.async() {
                self.image = image
                done()
            }
            }.resume()
    }
    func downloaded(from link: String,pin: Pin, contentMode mode: UIView.ContentMode = .scaleAspectFill,done: @escaping ()-> Void) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url,pin: pin) {
            
            done()
        }
    }
}
