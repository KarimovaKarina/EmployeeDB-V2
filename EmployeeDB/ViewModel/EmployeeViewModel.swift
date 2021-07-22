//
//  EmployeeViewModel.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import Foundation
import ContactsUI

class EmployeeViewModel {
    private var resource = ApiService()
    var employees = [EmployeeData]()
    var contact: CNContact?
    var positions = [String]()
    
    func numberOfSections() -> Int {
        let uniqueEmployeesByPosition = employees.unique(map: { $0.position })
        var sections = [String]()
        for employee in uniqueEmployeesByPosition {
            sections.append(employee.position)
        }
        positions = sections.sorted()
        return sections.count
    }
    
    func cellForRowAt (indexPath: IndexPath) -> EmployeeData {
        return employees[indexPath.row]
    }
    
    
    func groupEmployee() -> [String:[EmployeeData]] {
        var groupedEmployees =  [String: [EmployeeData]]()
        employees = employees.unique(map: {$0.fname.uppercased() + $0.lname.uppercased()})
        for position in positions {
            var employeeArray = [EmployeeData]()
            for employee in employees {
                if position == employee.position {
                    employeeArray.append(employee)
                }
            }
            groupedEmployees[position] = employeeArray.sorted { $0.lname < $1.lname }
        }
        return groupedEmployees
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

// MARK: - Extesion for Array to drop duplicates in [EmployeesData]()

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

