//
//  EmployeeDBTests.swift
//  EmployeeDBTests
//
//  Created by Карина Каримова on 20.07.2021.
//

import XCTest
@testable import EmployeeDB

class EmployeeDBTests: XCTestCase {
 
    var employeeVM = EmployeeViewModel()
    override func setUpWithError() throws {
        try super.setUpWithError()
        employeeVM.employees = [EmployeeData(fname: "Ivan", lname: "Popov", position: "ANDROID", contact_details: Contact(email: "ivan.popov@gmail.com", phone: nil), projects: nil),
                                EmployeeData(fname: "Ivan", lname: "Popov", position: "ANDROID", contact_details: Contact(email: "ivan.popov@gmail.com", phone: "123"), projects: nil),
                                EmployeeData(fname: "Gigi", lname: "Hadid", position: "IOS", contact_details: Contact(email: "gigi@gmail.com", phone: "123456"), projects: ["Vogue"]),
                                EmployeeData(fname: "Belli", lname: "Hadid", position: "WEB", contact_details: Contact(email: "bella@gmail.com", phone: nil), projects: ["die Zunge", "der Zahn"]),
                                EmployeeData(fname: "Polina", lname: "Popova", position: "ANDROID", contact_details: Contact(email: "polina.popova@gmail.com", phone: "555"), projects: nil)
        ]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        employeeVM.employees = []
    }

    func testFunctionThatTurnsArrayOfEmployeesDataIntoDictionary() {
        let expectedDictionary = [
            "ANDROID":
                [
                    EmployeeData(fname: "Ivan", lname: "Popov", position: "ANDROID", contact_details: Contact(email: "ivan.popov@gmail.com", phone: nil), projects: nil),
                    EmployeeData(fname: "Polina", lname: "Popova", position: "ANDROID", contact_details: Contact(email: "polina.popova@gmail.com", phone: "555"), projects: nil)
                ],
            "IOS":
                [
                    EmployeeData(fname: "Gigi", lname: "Hadid", position: "IOS", contact_details: Contact(email: "gigi@gmail.com", phone: "123456"), projects: ["Vogue"])
                ],
            "WEB":
                [
                    EmployeeData(fname: "Belli", lname: "Hadid", position: "WEB", contact_details: Contact(email: "bella@gmail.com", phone: nil), projects: ["die Zunge", "der Zahn"])
                ]]
        employeeVM.numberOfSections()
        XCTAssertEqual(employeeVM.groupEmployee(), expectedDictionary, "groupEmployees() should create dictionary of <String: [EmployeeData]>")
    }
    
    func testIfDictionaryHasUniqueEmployees() {
        let incorrectDictionary = [
            "ANDROID":
                [
                    EmployeeData(fname: "Ivan", lname: "Popov", position: "ANDROID", contact_details: Contact(email: "ivan.popov@gmail.com", phone: nil), projects: nil),
                    EmployeeData(fname: "Ivan", lname: "Popov", position: "ANDROID", contact_details: Contact(email: "ivan.popov@gmail.com", phone: "123"), projects: nil),
                    EmployeeData(fname: "Polina", lname: "Popova", position: "ANDROID", contact_details: Contact(email: "polina.popova@gmail.com", phone: "555"), projects: nil)
                ],
            "IOS":
                [
                    EmployeeData(fname: "Gigi", lname: "Hadid", position: "IOS", contact_details: Contact(email: "gigi@gmail.com", phone: "123456"), projects: ["Vogue"])
                ],
            "WEB":
                [
                    EmployeeData(fname: "Belli", lname: "Hadid", position: "WEB", contact_details: Contact(email: "bella@gmail.com", phone: nil), projects: ["die Zunge", "der Zahn"])
                ]]
        
        employeeVM.numberOfSections()
        XCTAssertFalse(incorrectDictionary == employeeVM.groupEmployee(), "groupEmployees() should create dictionary of <String: [EmployeeData]> with unique employees")
    }
    
    func testNumberOfSections(){
        let expectedNumberOfSections = 3
        XCTAssertEqual(employeeVM.numberOfSections(), expectedNumberOfSections, "numberOfSections() should return number of unique positions")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

