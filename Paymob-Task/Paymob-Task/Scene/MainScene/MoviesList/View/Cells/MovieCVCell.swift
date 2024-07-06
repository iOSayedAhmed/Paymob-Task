//
//  MovieCVCell.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import UIKit
import Combine
protocol MovieCVCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: MovieCVCell)
}


struct MovieCVCellViewModel {
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

class MovieCVCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    
    weak var delegate: MovieCVCellDelegate?
    
    var viewModel: MovieCVCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(viewModel: viewModel)
        }
    }
    var favoriteButtonTapped = PassthroughSubject<Movie, Never>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(viewModel: MovieCVCellViewModel) {
        loadImage(imageURL: viewModel.imageURL)
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        voteCountLabel.text = viewModel.voteCount
        ratingLabel.text = viewModel.rating
        favoriteButton.isSelected = viewModel.movie.isFavorite
        updateFavoriteButtonAppearance(isFavorite: viewModel.movie.isFavorite)
    }
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        favoriteButton.isSelected.toggle()
        delegate?.didTapFavoriteButton(in: self)
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
    
    func updateFavoriteButtonAppearance(isFavorite:Bool) {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

