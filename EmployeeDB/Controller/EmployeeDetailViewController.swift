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
    var employeeData: EmployeeData?
    var safeArea: UILayoutGuide!
    var tableView = UITableView()
    private var viewModel = EmployeeViewModel()
    var floatingButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        setupButton()
        
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
        let imageName = "contact-book"
        floatingButton.setImage(UIImage(named: imageName), for: .normal)
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
        }}

    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        if let data = viewModel.contact {
        let vc = CNContactViewController(for: data)
        vc.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        self.navigationController?.pushViewController(vc, animated: true)
        print("tapped")
        }
    }
}

extension EmployeeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let titles = ["Full Name", "Position", "E-mail", "Phone", "Projects"]
//        return titles[section]
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let label = UILabel()
        let titles = ["Full Name", "Position", "E-mail", "Phone", "Projects"]
        label.text = titles[section]
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
        var number = 1
        if section == 4 {
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
            if let name = employeeData?.fname, let lastname = employeeData?.lname{
                cell.textLabel?.text = name + " " + lastname
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
