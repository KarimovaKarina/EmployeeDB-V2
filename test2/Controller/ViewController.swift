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
    var filteredData = [EmployeeData]()
    var searchController = UISearchController(searchResultsController: nil)

    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        safeArea = view.safeAreaLayoutGuide
        setupSearchController()
        setupTableView()
        loadData()
        
        
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func filterData(for searchText: String) {
        let text = searchText.uppercased().replacingOccurrences(of: " ", with: "")
        filteredData = viewModel.employees
        filteredData = viewModel.dropDuplicates(list: filteredData).sorted { $0.lname < $1.lname }
        filteredData = filteredData.filter {
            ($0.fname.uppercased().contains(text)) ||
            ($0.lname.uppercased().contains(text)) ||
            ($0.fname.uppercased() + $0.lname.uppercased()).contains(text) ||
            ($0.contact_details.email.uppercased().contains(text)) ||
            ($0.position.uppercased().contains(text))
        }
        tableView.reloadData()
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
    
    func setupSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Type name, email or position"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let label = UILabel()
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        }
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredData.count
        }
        let dict = viewModel.groupEmployee()
        return dict[positions[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! EmpoyeeCell
        if searchController.isActive && searchController.searchBar.text != "" {
            let employee = filteredData[indexPath.row]
            let fullName = employee.lname + " " + employee.fname
            cell.textLabel?.text = fullName
            cell.check(str: fullName)
            return cell
        }
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
        var employee: EmployeeData?
        if searchController.isActive && searchController.searchBar.text != "" {
            employee = filteredData[indexPath.row]
        } else {
            employee = dict[positions[indexPath.section]]?[indexPath.row]
            
        }
        let employeeDetailVC = EmployeeDetailViewController()
        employeeDetailVC.employeeData = employee
        self.navigationController?.pushViewController(employeeDetailVC, animated: true)
        
    }
}
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterData(for: searchController.searchBar.text ?? "")
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setupSearchController()
    }
}


