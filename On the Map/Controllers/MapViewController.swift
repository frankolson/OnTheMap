//
//  MapViewController.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadLocations()
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) else {
                showAlert(title: "Invalid URL", message: "This pin has an invalid URL")
                return
            }
            
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: Actions

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        setRefreshing(true)
        loadLocations()
    }
    
    // MARK: Map helpers
    
    func refreshMapAnnotations() {
        var annotations = [MKPointAnnotation]()
        
        for student in StudentInformationModel.allStudents {
            let latitude =  CLLocationDegrees(student.latitude)
            let longitude =  CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = student.fullName
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    func setRefreshing(_ loggingIn: Bool) {
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func loadLocations() {
        UdacityClient.getStudentLocations { studentLocations, error in
            if error == nil {
                StudentInformationModel.allStudents = studentLocations
                self.refreshMapAnnotations()
                self.setRefreshing(false)
            } else {
                self.showAlert(title: "Locations Retrieval Failed", message: error?.localizedDescription ?? "")
            }
        }
    }
}
