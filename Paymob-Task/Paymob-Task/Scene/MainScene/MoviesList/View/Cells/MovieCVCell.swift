//
//  MovieCVCell.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import UIKit

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
}

class MovieCVCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    var viewModel: MovieCVCellViewModel! {
        didSet {
            configure(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(viewModel: MovieCVCellViewModel) {
        loadImage(imageURL: viewModel.imageURL)
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        voteCountLabel.text = viewModel.voteCount
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
