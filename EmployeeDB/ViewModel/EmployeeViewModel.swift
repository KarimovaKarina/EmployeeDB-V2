//
//  EmployeeViewModel.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import Foundation
import ContactsUI

class EmployeeViewModel {
    private var resource = EmployeeResource()
    var employees = [EmployeeData]()
    var contact: CNContact?
    var positions = [String]()
    
    
    func numberOfSections() -> Int {
        var count = 0
        var setOfPositions = Set<String>()
        for employee in employees {
            if setOfPositions.contains(employee.position) {
                count += 1
            }
            setOfPositions.insert(employee.position)
        }
        positions = Array(setOfPositions).sorted { $0 < $1 }
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
        var groupedEmployees =  [String: [EmployeeData]]()
        for position in positions {
            var employeeArray = [EmployeeData]()
            for employee in employees {
                if position == employee.position {
                    employeeArray.append(employee)
                }
            }
            employeeArray =  employeeArray.sorted { $0.lname < $1.lname }
            groupedEmployees[position] = dropDuplicates(from: employeeArray) 
        }
        return groupedEmployees
    }
    
    func dropDuplicates(from list: [EmployeeData]) -> [EmployeeData]{
        var checkSet = Set<String>()
        var allDataWithoutDuplicates: [EmployeeData] = []
        for employee in list{
            let fullName = employee.lname + employee.fname
            if checkSet.contains(fullName.lowercased()){
                continue
            }
            checkSet.insert(fullName.lowercased())
            allDataWithoutDuplicates.append(employee)
        }
        return allDataWithoutDuplicates
    }
    
    func fetchPhoneContacts() -> [CNContact]{
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys: [CNKeyDescriptor] = [CNContactViewController.descriptorForRequiredKeys()]
        
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
                self.contact = contact
                return true
            }
        }
        return false
    }
}
