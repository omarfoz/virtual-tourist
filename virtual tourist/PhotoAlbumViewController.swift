//
//  PhotoAlbumViewController.swift
//  virtual tourist
//
//  Created by Omar Yahya Alfawzan on 5/26/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, MKMapViewDelegate {
    @IBOutlet weak var vTCollectionVew: UICollectionView!
    @IBOutlet weak var newCollectionbutton: UIButton!
    @IBOutlet weak var vTMapView: MKMapView!
    @IBOutlet weak var flowCollectionView: UICollectionViewFlowLayout!
    var arrDBImage = [UIImage]()
    var pin:Pin?
    var coordinates:CLLocationCoordinate2D?
    var arrFlickerImages = [FlickerImage]()
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        vTCollectionVew.delegate = self
        vTCollectionVew.dataSource = self
        setUpMap()
        let space:CGFloat = 3.0
        let dimension = (vTCollectionVew.frame.size.width - (2 * space)) / 3.0
        flowCollectionView.minimumInteritemSpacing = space
        flowCollectionView.minimumLineSpacing = space
        flowCollectionView.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    func setUpMap(){
        vTMapView.delegate = self
        coordinates = CLLocationCoordinate2DMake(pin!.latitude, pin!.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates!
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: coordinates!, span: span)
        vTMapView.setRegion(region, animated: true)
        vTMapView.addAnnotation(annotation)
        if arrDBImage.count == 0 {
        if arrFlickerImages.count == 0 {
        self.showFailureFromViewController(viewController: self, message: "there is no pictures in this pin")
          }
        }
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pin?.images?.count != 0 { return self.arrDBImage.count }
        return self.arrFlickerImages.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if pin?.images?.count != 0 {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VTCollectionViewCell", for: indexPath) as! VTCollectionViewCell
         let img = self.arrDBImage[indexPath.row]
         cell.setCellFromDB(image: img)
         return cell
            
     } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VTCollectionViewCell", for: indexPath) as! VTCollectionViewCell
        let img = self.arrFlickerImages[indexPath.row]
        cell.setCell(img: img.urlM,pin: pin!)
        return cell
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
         if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    @IBAction func pressNewCollection(_ sender: Any) {
        
        FlickrClient.searchPhotos(latitude: coordinates!.latitude, longitude: coordinates!.longitude, done: { (arrImgs) in
        self.arrFlickerImages = [FlickerImage]()
        self.arrDBImage = [UIImage]()
        ImageManager.deleteImages(pin: self.pin!)
        self.arrFlickerImages = arrImgs
        self.vTCollectionVew.reloadData()
            
        }) { (Error) in
        self.showFailureFromViewController(viewController: self, message: Error.localizedDescription)
        }
     }
}

