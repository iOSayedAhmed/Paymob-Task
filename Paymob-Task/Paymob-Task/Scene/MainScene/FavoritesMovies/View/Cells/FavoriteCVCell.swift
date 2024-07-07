//
//  MovieCVCell.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import UIKit
import Combine

struct FavoriteCVCellViewModel {
    private let config = ConfigurationManager.shared
  
    let movie: Movie
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    
    var date: String {
        return movie.releaseDate
    }
    
    var voteCount: String {
        return "Vote Count: \(movie.voteCount)"
    }
    
    var imageURL: String {
        if let imageURL = try? config.xconfigValue(key: .imageURL) {
            return  "\(imageURL)\(movie.posterPath)"
        }
        return ""
    }
    
    var rating: String {
        let formattedVoteAverage = String(format: "%.2f", movie.voteAverage ?? 0.0)
        return "Rating \(formattedVoteAverage) ⭐️"
    }
}

class FavoriteCVCell: UICollectionViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var voteCountLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    
    var viewModel: FavoriteCVCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(viewModel: FavoriteCVCellViewModel) {
        loadImage(imageURL: viewModel.imageURL)
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        voteCountLabel.text = viewModel.voteCount
        ratingLabel.text = viewModel.rating
    }
    
    
    @MainActor func loadImage(imageURL: String) {
        ImageLoader.loadImage(from: imageURL) {[weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.movieImageView.image = image
                } else {
                    self?.movieImageView.image = UIImage(named: "image_placeholder")
                }
            }
        }
    }
}

