//
//  FindLocationViewController.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit
import CoreLocation
import MapKit

class FindLocationViewController: UIViewController {
    
    // MARK: Attributes
    
    var location: CLLocation!
    var locationString: String!
    var urlString: String!

    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMapAnnotation()
    }
    
    // MARK: MKMapViewDelegate
    
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
    
    // MARK: Actions
    
    @IBAction func submitLocation(_ sender: Any) {
        setSubmitting(true)
        UdacityClient.postStudentLocation(
            mapString: locationString,
            mediaUrl: urlString,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            completion: handleSubmissionResponse(success:error:)
        )
    }
    

    // MARK: Helpers
    
    func setMapAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = locationString
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
    
    func setSubmitting(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func handleSubmissionResponse(success: Bool, error: Error?) {
        setSubmitting(false)
        if success {
            dismiss(animated: true)
        } else {
            showAlert(title: "Location Submission Failed", message: error?.localizedDescription ?? "")
        }
    }

}
