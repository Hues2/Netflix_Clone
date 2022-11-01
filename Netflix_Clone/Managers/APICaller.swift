//
//  APICaller.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import Foundation


enum ApiUrl{
    case TRENDING, UPCOMING, POPULAR, TOPRATED, DISCOVER
}

enum showType: String{
    case movie, tv
}

enum APIError: String, Error{
    case invalidData = "The data returned from the API call was nil"
    case returnedError = "The API repsonse contained an error"
    case unableToDecode = "Could not decode the JSON response"
}



class APICaller{
    static let shared = APICaller()
    
    private init(){}
    
    //MARK: - Trending
    func getShows(type: showType, apiUrl: ApiUrl, completion: @escaping (Result<[Show], APIError>) -> ()){
        
        var urlString: String
        
        switch apiUrl{
        case .TRENDING:
            urlString = "\(Constants.baseURL)/3/trending/\(type.rawValue)/day?api_key=\(Constants.API_KEY)"
        
        case .POPULAR:
            urlString = "\(Constants.baseURL)/3/\(type.rawValue.lowercased())/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
            
        case.TOPRATED:
            urlString = "\(Constants.baseURL)/3/\(type.rawValue)/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
            
        case .UPCOMING:
            urlString = "\(Constants.baseURL)/3/\(type.rawValue)/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
            
        case .DISCOVER:
            urlString = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard error == nil else{
                completion(.failure(.returnedError))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            
            do {
                let results = try JSONDecoder().decode(TrendingShowsResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    
    
    func search(with query: String, completion: @escaping (Result<[Show], APIError>) -> ()){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard error == nil else{
                completion(.failure(.returnedError))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            
            do {
                let results = try JSONDecoder().decode(TrendingShowsResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, APIError>) -> ()){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseYoutubeURL)q=\(query)&key=\(Constants.YOUTUBE_API_KEY)") else { return }
        
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard error == nil else{
                completion(.failure(.returnedError))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                guard let first = results.items.first else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                completion(.success(first))

            } catch {
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
        
    }
    
}
