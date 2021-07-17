//
//  ViewController.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import UIKit
import Contacts
import ContactsUI


class ViewController: UIViewController {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    private var viewModel = EmployeeViewModel()
    var positions = ["ANDROID", "IOS", "OTHER", "PM", "SALES", "TESTER", "WEB"]
    var contact1 = CNContact()
    let resource = EmployeeResource()

    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        safeArea = view.safeAreaLayoutGuide
        setupTableView()
        loadData()
        self.navigationController?.navigationBar.topItem?.title = "EmployeeDB"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)]
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }
    
    @objc func loadData(){
        resource.getEmployee() { (response) in
            self.viewModel.employees = response!
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(EmpoyeeCell.self, forCellReuseIdentifier: "cellID")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let label = UILabel()
        label.text = positions[section]
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
        let dict = viewModel.groupEmployee()
        return dict[positions[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! EmpoyeeCell
        let dict = viewModel.groupEmployee()
        
        guard let datasource = dict[positions[indexPath.section]] else {
            return UITableViewCell()
        }
        let fullName = datasource[indexPath.row].lname + " " + datasource[indexPath.row].fname
        cell.check(str: fullName)
        cell.textLabel?.text = fullName
        cell.onTap = { [weak self] (contact) in
            let vc = CNContactViewController(for: contact)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = viewModel.groupEmployee()
        let employee = dict[positions[indexPath.section]]?[indexPath.row]
        let employeeDetailVC = EmployeeDetailViewController()
        employeeDetailVC.employeeData = employee
        self.navigationController?.pushViewController(employeeDetailVC, animated: true)
        
    }
}


