//
//  TableViewController.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationModel.allStudents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath)
        let studentInformation = StudentInformationModel.allStudents[indexPath.row]
        
        cell.textLabel?.text = studentInformation.fullName
        cell.detailTextLabel?.text = studentInformation.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let toOpen = cell?.detailTextLabel?.text, let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) else {
            showAlert(title: "Invalid URL", message: "This pin has an invalid URL")
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    // MARK: Actions

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        setRefreshing(true)
        loadLocations()
    }
    
    // MARK: Helpers
    
    func setRefreshing(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func loadLocations() {
        UdacityClient.getStudentLocations { studentLocations, error in
            if error == nil {
                StudentInformationModel.allStudents = studentLocations
                self.tableView.reloadData()
                self.setRefreshing(false)
            } else {
                self.showAlert(title: "Locations Retrieval Failed", message: error?.localizedDescription ?? "")
            }
        }
    }

}
