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

class AddParking: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController!
    var searchController: UISearchController!
    var resultView: UITextView!
    var scrollView: UIScrollView!
    @IBOutlet weak var parkingAmount: UITextField!
    @IBOutlet weak var parkingStartDateTime: UIDatePicker!
    @IBOutlet weak var parkingEndDateTime: UIDatePicker!
    @IBOutlet weak var parkingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar.current
        parkingStartDateTime.minimumDate = calendar.startOfDay(for: Date())
        parkingEndDateTime.minimumDate = calendar.date(byAdding: .minute, value: 60, to: parkingStartDateTime.date)
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "Search Address"
        searchController.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 5, y: 60.0, width: 402.0, height: 45.0))
        
        subView.addSubview((searchController.searchBar))
        view.addSubview(subView)
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        parkingImage.image = UIImage(named: "placeholder")

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

    @IBAction func imagePicker(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            parkingImage.image = chosenImage
        }
        
        // use the image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddParking: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController.isActive = false
        searchController.searchBar.text = place.formattedAddress!
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
