//
//  StorageManager.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import CoreData
import UIKit

class StorageManager {
    private let config = ConfigurationManager.shared
    static let shared = StorageManager()
    
    private init() {}
    
    private let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
    
    
    public func saveMovies(movies: [Movie]) {
        container.performBackgroundTask { context in
            self.deleteOldSavedItems(context: context)
            self.cachAllMovies(movies: movies, context: context)
        }
    }
    
    private func deleteOldSavedItems(context: NSManagedObjectContext) {
        do {
            let oldMovies = try context.fetch(fetchRequest)
            _ = oldMovies.map { context.delete($0) }
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func cachAllMovies(movies: [Movie], context: NSManagedObjectContext) {
        context.perform {
            for movie in movies {
                let entity = Item(context: context)
                entity.title = movie.title
                entity.overView = movie.overview
                entity.releaseDate = movie.releaseDate
                entity.voteCount = Int32(movie.voteCount)
                entity.image = movie.posterPath
                entity.backgroundImage = movie.backdropPath
                entity.genreIds = movie.genreIDS.map { String($0) }.joined(separator: ",")
            }
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    public func fetchMovies() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let items = try container.viewContext.fetch(fetchRequest)
            return items
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }
}

