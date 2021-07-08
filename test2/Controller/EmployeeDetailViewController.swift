//
//  EmployeeDetailViewController.swift
//  test2
//
//  Created by Карина Каримова on 29.06.2021.
//

import UIKit

class EmployeeDetailViewController: UIViewController {
    var employeeData: EmployeeData?
    var safeArea: UILayoutGuide!
    var tableView = UITableView()
    private var viewModel = EmployeeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }

    func setupTableView(){
        view.addSubview(tableView)

        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
}

extension EmployeeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["First Name", "Last Name", "Position", "E-mail", "Phone", "Projects"]
        return titles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 1
        if section == 5 {
            if let count = employeeData?.projects?.count{
                number = count
            }
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = employeeData?.fname
            return cell
        case 1:
            cell.textLabel?.text = employeeData?.lname
            return cell
        case 2:
            cell.textLabel?.text = employeeData?.position
            return cell
        case 3:
            cell.textLabel?.text = employeeData?.contact_details.email
            return cell
        case 4:
            let phone = employeeData?.contact_details.phone
            if ((phone?.isEmpty) != nil) {
                cell.textLabel?.text = phone
            }
            else {
                cell.textLabel?.text = "-"
            }
            return cell
        case 5:
            if let projects = employeeData?.projects{
                cell.textLabel?.text = projects[indexPath.row]
            } else {
                cell.textLabel?.text = "-"
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
