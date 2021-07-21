//
//  Utility.swift
//  test2
//
//  Created by Карина Каримова on 17.07.2021.
//

import Foundation

struct HttpUtility {
    
    static let shared = HttpUtility()
    private init() {}
    
    public func request<T:Decodable>(urlRequest: URLRequest, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void) {
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, urlResponse, error) in
            if(error == nil && serverData != nil){
                do {
                    let result = try JSONDecoder().decode(T.self, from: serverData!)
                    completionHandler(result)
                } catch {
                    debugPrint("parser error = \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
