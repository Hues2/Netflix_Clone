//
//  DataPersistenceManager.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 04/11/2022.
//

import Foundation
import CoreData
import UIKit


class DataPersistenceManager{
    
    enum DatabaseError: Error{
        case failedToSaveData
        case failedFetchingShows
        case failedToDeleteData
    }

    static let shared = DataPersistenceManager()
    
    
    private init(){}
    
    func downloadShowWith(show: Show, completion: @escaping (Result<Void, Error>) -> ()){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let showItem = ShowItem(context: context)

        showItem.original_title = show.original_title
        showItem.original_name = show.original_name
        showItem.overview = show.overview
        showItem.id = Int64(show.id)
        showItem.media_type = show.media_type
        showItem.poster_path = show.poster_path
        showItem.release_date = show.release_date
        showItem.vote_average = show.vote_average
        showItem.vote_count = Int64(show.vote_count)
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch{
            completion(.failure(DatabaseError.failedToSaveData))
        }
        
    }
    
    
    
    
    func fetchShowsFromDatabase(completion: @escaping (Result<[ShowItem], Error>) -> ()){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let shows = try context.fetch(NSFetchRequest<ShowItem>(entityName: "ShowItem"))
            completion(.success(shows))
        } catch {
            completion(.failure(DatabaseError.failedFetchingShows))
        }
    }
    
    
    func deleteShowWith(show: ShowItem, completion : @escaping (Result<Void, Error>) -> ()){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(show)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
}
