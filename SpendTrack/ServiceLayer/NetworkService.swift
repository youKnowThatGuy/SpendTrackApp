//
//  NetworkService.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import Foundation
import UIKit

class NetworkService{
    private init(){}
    static let shared = NetworkService()
    private let apiKey = "DE2955ADF5814B549899473A5E01FD54"
    private let amount = 30
    
    private var baseUrlComponent: URLComponents {
        var _urlComps = URLComponents(string: "https://api.scaleserp.com/search")!
        _urlComps.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "search_type", value: "shopping"),
            URLQueryItem(name: "location", value: "Russia"),
            URLQueryItem(name: "num", value: "\(amount)")
        ]
        return _urlComps
    }
    
    func fetchSearchData(query: String, completion: @escaping (Result<[SingleResult], SessionError>) -> Void){
        var urlComps = baseUrlComponent
        urlComps.queryItems? += [
        URLQueryItem(name: "q", value: query),
        ]
        
        guard let url = urlComps.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidUrl))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            let response = response as! HTTPURLResponse
            
            guard let data = data, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode(ServerResponse<SingleResult>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(serverResponse.shopping_results))
                }
            }
            catch let decodingError{
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError)))
                }
                
            }
            
        }.resume()
    }
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void){
        guard let url = url else{
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data{
                    completion(UIImage(data: data))
                }
                else{
                    completion(nil)
                }
            }
        }.resume()
    }
    
}
