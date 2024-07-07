//
//  StorageManager.swift
//  Paymob-Task
//
//  Created by iOSAYed on 07/07/2024.
//

import CoreData
import UIKit
import Combine

class StorageManager {
    static let shared = StorageManager()

    private init() {}

    private let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
    let favoritesDidChange = PassthroughSubject<Void, Never>()
    
    public func saveFavorite(movie: Movie) {
        container.performBackgroundTask { context in
            let entity = Item(context: context)
            entity.id = Int32(movie.id ?? 0)
            entity.title = movie.title
            entity.overView = movie.overview
            entity.releaseDate = movie.releaseDate
            entity.voteCount = Int32(movie.voteCount)
            entity.image = movie.posterPath
            entity.backgroundImage = movie.backdropPath
            entity.genreIds = movie.genreIDS.map { String($0) }.joined(separator: ",")
            entity.isFavorite = movie.isFavorite
            entity.voteAverage = movie.voteAverage ?? 0.0

            do {
                try context.save()
                self.favoritesDidChange.send(())
            } catch {
                print(error)
            }
        }
    }

    public func deleteFavorite(movie: Movie) {
        container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id ?? 0)

            do {
                let items = try context.fetch(fetchRequest)
                for item in items {
                    context.delete(item)
                }
                try context.save()
                self.favoritesDidChange.send(())
            } catch {
                print(error)
            }
        }
    }

    public func fetchFavorites() -> [Item] {
        do {
            let items = try container.viewContext.fetch(fetchRequest)
            return items
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
}
