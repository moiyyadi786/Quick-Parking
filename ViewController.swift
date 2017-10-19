//
//  ViewController.swift
//  Quick Parking
//
//  Created by Mac27 on 10/9/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, UITextFieldDelegate {

    var resultsViewController: GMSAutocompleteResultsViewController!
    var searchController: UISearchController!
    var resultView: UITextView!
    var mapView: GMSMapView!
    var marker: GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // reating mapView
        mapView = GMSMapView.init(frame: CGRect.init(x: 20, y: 20, width: 400, height: 600))
        view.addSubview(mapView)
        mapView.center = self.view.center
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 5, y: 30.0, width: 402.0, height: 45.0))
        
        subView.addSubview((searchController.searchBar))
        view.addSubview(subView)
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true

        // initialize map with default location
        let location: NSDictionary = [
            "title": "Sydney",
            "snippet": "Australia"
        ]
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.addMarker(location: location as NSDictionary, camera: camera as GMSCameraPosition);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

    func addMarker(location: NSDictionary, camera: GMSCameraPosition) -> Void{
        mapView.camera = camera;
        marker = GMSMarker(position: camera.target)
        marker.title = location["title"] as? String
        marker.snippet = location["snippet"] as? String
        marker.map = mapView
    }
}

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController.isActive = false
        searchController.searchBar.text = place.formattedAddress!
        mapView.clear()

        let currentLocation: NSDictionary = [
            "title": place.name,
            "snippet": place.name,
            "address": place.formattedAddress as Any
        ]
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 6.0)
        self.addMarker(location: currentLocation as NSDictionary, camera: camera as GMSCameraPosition)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

