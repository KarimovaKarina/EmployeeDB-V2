//
//  EmployeeViewModel.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import Foundation

class EmployeeViewModel {
    private var apiService = ApiService()
    private var employees = [EmployeeData]()
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        apiService.getPopularMoviesData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.employees = listOf.employees
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfSections() -> Int {
        var count = 0
        var setOfPositions = Set<String>()
        for employee in employees {
            if setOfPositions.contains(employee.position) {
                count += 1
            }
            setOfPositions.insert(employee.position)
        }
        return setOfPositions.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if employees.count != 0 {
            return employees.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> EmployeeData {
        return employees[indexPath.row]
    }
    
    func groupEmployee() -> [String:[EmployeeData]] {
        var datasource =  [String: [EmployeeData]]()
        let positions = ["ANDROID", "IOS", "OTHER", "PM", "SALES", "TESTER", "WEB"]
        for position in positions {
            var employeeArray = [EmployeeData]()
            for employee in employees {
                if position == employee.position {
                    employeeArray.append(employee)
                }
            }
            employeeArray =  employeeArray.sorted { $0.lname < $1.lname }
            datasource[position] = employeeArray
        }
        return datasource
    }
    
    func numberOfRowsInSectionForDetailVC() {
        
    }
}
