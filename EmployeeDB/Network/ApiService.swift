//
//  ApiService.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//
//
//import Foundation
//
//class ApiService {
//
//    private var dataTask: URLSessionDataTask?
//
//    func getEmployeesData(completion: @escaping (Result<EmployeesList, Error>) -> Void) {
//
//        let employeesListURL = "https://tallinn-jobapp.aw.ee/employee_list/"
//        let emplyeesListURL2 = "https://tartu-jobapp.aw.ee/employee_list/"
//
//        guard let url = URL(string: employeesListURL) else {return}
//
//        // Create URL Session - work on the background
//        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            // Handle Error
//            if let error = error {
//                completion(.failure(error))
//                print("DataTask error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else {
//                // Handle Empty Response
//                print("Empty Response")
//                return
//            }
//            print("Response status code: \(response.statusCode)")
//
//            guard let data = data else {
//                // Handle Empty Data
//                print("Empty Data")
//                return
//            }
//
//            do {
//                // Parse the data
//                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(EmployeesList.self, from: data)
//
//                // Back to the main thread
//                DispatchQueue.main.async {
//                    completion(.success(jsonData))
//                }
//            } catch let error {
//                completion(.failure(error))
//            }
//
//        }
//        dataTask?.resume()
//    }
//}

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

