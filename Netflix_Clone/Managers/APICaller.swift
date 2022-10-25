//
//  APICaller.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import Foundation


struct Constants{
    static let API_KEY = ""
    static let baseURL = "https://api.themoviedb.org"
}


class APICaller{
    static let shared = APICaller()
    
    private init(){}
    
    
    func getTrending(type: String, completion: @escaping (Result<[Movie], Error>) -> ()){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/\(type)/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard error == nil else{
                print("\n 1.--> \(error?.localizedDescription ?? "Error fetching trending movies") \n")
                return
            }
            
            guard let data else {
                print("\n Data is nill \n")
                return
            }
            
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                print("\n 2.--> \(error.localizedDescription) \n")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
