//
//  ApiService.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//


import Foundation

struct EmployeeResource {
    
    func getEmployee(completion: @escaping(_ result: [EmployeeData]?)-> Void)
    {
        let url1 = "https://tartu-jobapp.aw.ee/employee_list/"
        let url2 = "https://tallinn-jobapp.aw.ee/employee_list/"
        
        let urls = [url1, url2]
        var employees : [EmployeeData] = []
        
        let dispatchGroup = DispatchGroup()
        
        urls.forEach { (request) in
            dispatchGroup.enter()
            getEmployee(url: request) { (response) in
                employees.append(contentsOf: (response?.employees.map{$0})!)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(employees)
        }
    }
    
    
    func getEmployee(url: String, completion: @escaping(_ result: EmployeesList?) -> Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "get"
        
        HttpUtility.shared.request(urlRequest: request, resultType: EmployeesList.self) { (response) in
            completion(response)
        }
    }
}

