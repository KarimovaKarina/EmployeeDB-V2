//
//  EmployeeDetailViewController.swift
//  test2
//
//  Created by Карина Каримова on 29.06.2021.
//

import UIKit
import Contacts
import ContactsUI

class EmployeeDetailViewController: UIViewController {
    
    private var viewModel = EmployeeViewModel()
    var safeArea: UILayoutGuide!
    var tableView = UITableView()
    var floatingButton = UIButton()
    var employeeData: EmployeeData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
        setupNavigationController()
        setupButton()
    }
    
    func setupNavigationController(){
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.08180698007, green: 0.1980696023, blue: 0.2411591411, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setupButton(){
        floatingButton.setImage(UIImage(named: K.contactIcon), for: .normal)
        view.addSubview(floatingButton)
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        floatingButton.addTarget(self,
                                 action: #selector(buttonAction),
                                 for: .touchUpInside)
        
        if let fname = employeeData?.fname, let lname = employeeData?.lname{
            if viewModel.matchContacts(lname + " " + fname){
                floatingButton.isHidden = false
            } else {
                floatingButton.isHidden = true
            }
        }
        
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        if let data = viewModel.contact {
            let vc = CNContactViewController(for: data)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EmployeeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let label = UILabel()
        label.text = K.titlesForDetailVC[section]
        vw.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: vw.leadingAnchor, constant: 18).isActive = true
        label.centerYAnchor.constraint(equalTo: vw.centerYAnchor).isActive = true
        vw.backgroundColor = #colorLiteral(red: 0.08180698007, green: 0.1980696023, blue: 0.2411591411, alpha: 1)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        if section == 4 {
            if let count = employeeData?.projects?.count{
                numberOfRows = count
            }
        }
        return numberOfRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let fname = employeeData?.fname, let lname = employeeData?.lname{
                cell.textLabel?.text = fname + " " + lname
            }
            return cell
        case 1:
            cell.textLabel?.text = employeeData?.position
            return cell
        case 2:
            cell.textLabel?.text = employeeData?.contact_details.email
            return cell
        case 3:
            let phone = employeeData?.contact_details.phone
            if ((phone?.isEmpty) != nil) {
                cell.textLabel?.text = phone
            }
            else {
                cell.textLabel?.text = "-"
            }
            return cell
        case 4:
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
