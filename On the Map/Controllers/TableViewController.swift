//
//  TableViewController.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UdacityClient.getStudentLocations { studentLocations, Error in
            StudentInformationModel.allStudents = studentLocations
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationModel.allStudents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath)
        let studentInformation = StudentInformationModel.allStudents[indexPath.row]
        
        cell.textLabel?.text = studentInformation.fullName
        cell.detailTextLabel?.text = studentInformation.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let toOpen = cell?.detailTextLabel?.text, let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) else {
            showAlert(title: "Invalid URL", message: "This pin has an invalid URL")
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }

}
