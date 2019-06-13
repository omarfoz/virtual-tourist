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
    var fetchedResultsController:NSFetchedResultsController<Images>!
    var arrDBImage = [UIImage]()
    var pin:Pin?
    var deleteflag:Bool = false
    var coordinates:CLLocationCoordinate2D?
    var arrFlickerImages = [FlickerImage]()
    var selectedImageToDelete:[Images]?
    var selectedIndexPath = IndexPath()
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupFetchedResultsController()
    ensurePhotosAppearance()
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        selectedImageToDelete = [Images]()
        deleteflag = false
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
    }
    
    fileprivate func ensurePhotosAppearance() {
        if fetchedResultsController.fetchedObjects?.count == 0 {
            loadPhotos()
        }
    }
    
    func loadPhotos() {
        FlickrClient.searchPhotos(latitude: self.pin!.latitude, longitude: self.pin!.longitude, done: { images in
            
            if images.count == 0 {
                self.showFailureFromViewController(viewController: self, message: "There is no photos in here")
            }
            else {
                ImageManager.savePhotos(pin: self.pin!, images: images)
            }
            
        }) { (error) in
            self.showFailureFromViewController(viewController: self, message: error.localizedDescription)
        }
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VTCollectionViewCell", for: indexPath) as! VTCollectionViewCell
        cell.image = image
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.clear.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        var cell = collectionView.cellForItem(at: indexPath)
        if cell!.layer.borderWidth != 0.0 {
            newCollectionbutton.setTitle("Remove Selected Pictures", for: .normal)
            deleteflag = true
            let photoToBeDeselect = fetchedResultsController.object(at: indexPath)
            if let index = selectedImageToDelete!.index(of:photoToBeDeselect){
                selectedImageToDelete!.remove(at: index)
            }
            cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0
            cell?.layer.borderColor = UIColor.gray.cgColor
            
            if selectedImageToDelete!.isEmpty {
                newCollectionbutton.setTitle("New Collection", for: .normal)
                deleteflag = false
            }
        }
        else {// select
            let photoToBeDeleted = fetchedResultsController.object(at: indexPath)
            newCollectionbutton.setTitle("Remove Selected Pictures", for: .normal)
            deleteflag = true
            selectedImageToDelete!.append(photoToBeDeleted)
            cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 10.0
            cell?.layer.borderColor = UIColor.gray.cgColor
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
        if deleteflag {
            newCollectionbutton.setTitle("New Collection", for: .normal)
            ImageManager.deletePhotos(photos: selectedImageToDelete!)
            selectedImageToDelete = [Images]()
            deleteflag = false
        }else {
        newCollectionbutton.setTitle("New Collection", for: .normal)
        guard fetchedResultsController.fetchedObjects!.count > 0 else {
            return
        }
        ImageManager.deletePhotos(photos: fetchedResultsController.fetchedObjects!)
        loadPhotos()
    }
    }
}

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Images> = Images.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "pin == %@", pin!)
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert,.delete :
            vTCollectionVew.reloadData()
        default:
            break
        }
    }
    
}
