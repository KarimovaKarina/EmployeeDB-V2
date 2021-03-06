//
//  EmployeeData.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import Foundation

struct EmployeesList: Codable {
    let employees: [EmployeeData]
}

struct EmployeeData: Codable{
    
    let fname: String
    let lname: String
    let position: String
    let contact_details: Contact
    let projects: [String]?
}

struct Contact: Codable {
    let email: String
    let phone: String?
}

extension EmployeeData: Hashable, Equatable{
    static func ==(lhs: EmployeeData, rhs: EmployeeData) -> Bool {
        return lhs.fname == rhs.fname && lhs.lname == rhs.lname && lhs.position == rhs.position
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(fname)
        hasher.combine(lname)
        hasher.combine(position)
    }

}
