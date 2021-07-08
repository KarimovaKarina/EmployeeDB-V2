//
//  EmployeeViewModel.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import Foundation
import ContactsUI

class EmployeeViewModel {
    private var apiService = ApiService()
    private var employees = [EmployeeData]()
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        apiService.getEmployeesData { [weak self] (result) in
            
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
    
    func fetchPhoneContacts() -> [CNContact]{
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)

        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                contacts.append(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
        return contacts
    }
    
    func matchContacts(_ fullName: String) -> Bool {
        let phoneContacts = fetchPhoneContacts()
        
            for contact in phoneContacts {
                let name = contact.familyName + " " + contact.givenName
                if name == fullName {
                    print(name)
                    return true
                }
           }
        return false
    }
}
