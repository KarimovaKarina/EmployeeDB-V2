//
//  ViewController.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import UIKit


class ViewController: UIViewController {

    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    private var viewModel = EmployeeViewModel()
    var positions = ["ANDROID", "IOS", "OTHER", "PM", "SALES", "TESTER", "WEB"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        safeArea = view.safeAreaLayoutGuide
        setupTableView()
        loadData()

    }
    func loadData(){
        viewModel.fetchPopularMoviesData { [weak self] in
                   self?.tableView.dataSource = self
                   self?.tableView.reloadData()
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
        label.leadingAnchor.constraint(equalTo: vw.leadingAnchor, constant: 15).isActive = true
        label.centerYAnchor.constraint(equalTo: vw.centerYAnchor).isActive = true
        vw.backgroundColor = #colorLiteral(red: 0.1078080311, green: 0.261521101, blue: 0.2835475802, alpha: 1)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        cell.textLabel?.text = datasource[indexPath.row].lname + " " + datasource[indexPath.row].fname
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = viewModel.groupEmployee()
        let employee = dict[positions[indexPath.section]]?[indexPath.row]
        let employeeDetailVC = EmployeeDetailViewController()
        employeeDetailVC.employeeData = employee
        self.present(employeeDetailVC, animated: true )
    }
}

