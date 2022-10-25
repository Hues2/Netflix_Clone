//
//  Show.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import Foundation


struct TrendingShowsResponse: Codable{
    let results: [Show]
}


struct Show: Codable{
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
