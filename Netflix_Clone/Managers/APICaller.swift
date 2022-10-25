//
//  APICaller.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import Foundation


class APICaller{
    static let shared = APICaller()
    
    private init(){}
    
    //MARK: - Trending
    func getTrending(type: String, completion: @escaping (Result<[Show], Error>) -> ()){
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
                let results = try JSONDecoder().decode(TrendingShowsResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                print("\n 2.--> \(error.localizedDescription) \n")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - Upcoming
    func getUpcomingMovies(type: String, completion: @escaping (Result<[Show], Error>) -> ()){
        guard let url = URL(string: "\(Constants.baseURL)/3/\(type)/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard error == nil else{
                print("\n 1.--> \(error?.localizedDescription ?? "Error fetching trending movies") \n")
                return
            }
            
            guard let data else { print("\n Data is nill \n"); return}
            
            
            do {
                let results = try JSONDecoder().decode(TrendingShowsResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                print("\n 2.--> \(error.localizedDescription) \n")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - Popular
    func getPopular(type: String, completion: @escaping (Result<[Show], Error>) -> ()){
        guard let url = URL(string: "\(Constants.baseURL)/3/\(type)/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard error == nil else{
                print("\n 1.--> \(error?.localizedDescription ?? "Error fetching trending movies") \n")
                return
            }
            
            guard let data else { print("\n Data is nill \n"); return}
            
            
            do {
                let results = try JSONDecoder().decode(TrendingShowsResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                print("\n 2.--> \(error.localizedDescription) \n")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTopRated(type: String, completion: @escaping (Result<[Show], Error>) -> ()){
        guard let url = URL(string: "\(Constants.baseURL)/3/\(type)/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard error == nil else{
                print("\n 1.--> \(error?.localizedDescription ?? "Error fetching trending movies") \n")
                return
            }
            
            guard let data else { print("\n Data is nill \n"); return}
            
            
            do {
                let results = try JSONDecoder().decode(TrendingShowsResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                print("\n 2.--> \(error.localizedDescription) \n")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
