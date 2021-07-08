//
//  ApiService.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//

import Foundation

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    
    func getEmployeesData(completion: @escaping (Result<EmployeesList, Error>) -> Void) {
        
        let employeesListURL = "https://tallinn-jobapp.aw.ee/employee_list/"
        
        guard let url = URL(string: employeesListURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(EmployeesList.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
}
//import Foundation
//
//class ApiService {
//
//    private var dataTask: URLSessionDataTask?
//
//    func getEmployeesData(completion: @escaping (Result<EmployeesList, Error>) -> Void) {
//        let group = DispatchGroup()
//
//        let urls = [
//            URL(string: "https://tallinn-jobapp.aw.ee/employee_list/"),
//            URL(string: "https://tartu-jobapp.aw.ee/employee_list")
//        ]
////        let employeesListURL = "https://tallinn-jobapp.aw.ee/employee_list/"
//        for url in urls {
//            group.enter()
//        guard let url = url else {return}
//
//        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if let error = error {
//                completion(.failure(error))
//                print("DataTask error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else {
//                print("Empty Response")
//                return
//            }
//            print("Response status code: \(response.statusCode)")
//
//            guard let data = data else {
//                print("Empty Data")
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(EmployeesList.self, from: data)
//
//                DispatchQueue.main.async {
//                    completion(.success(jsonData))
//                }
//            } catch let error {
//                completion(.failure(error))
//            }
//            group.leave()
//        }
//        dataTask?.resume()
//        }
//    }
//}
