//
//  MovieDetailsViewController.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Combine
import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var genreIdsLabel: UILabel!
    @IBOutlet private var releaseNoteLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var overviewTextView: UITextView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var favoriteButton: UIButton!
    var viewModel: MovieDetailsViewModel?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: MovieDetailsViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

    private func setupViews() {
        navigationController?.navigationBar.tintColor = .black
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        overviewTextView.text = viewModel.overview
        genreIdsLabel.text = viewModel.genreIds
        releaseNoteLabel.text = viewModel.releaseDate
        ratingLabel.text = viewModel.rating
        genreIdsLabel.isHidden = viewModel.genreIds.isEmpty
        
        activityIndicator.startAnimating()
        ImageLoader.loadImage(from: viewModel.imageURL) { [weak self] image in
            guard let self else { return }
            activityIndicator.stopAnimating()
            
            if let image = image {
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            } else {
                self.movieImageView.image = UIImage(named: "image_placeholder")
            }
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        viewModel?.toggleFavorite()
    }

    private func updateFavoriteButtonAppearance(isFavorite: Bool) {
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
    private func bindViewModel() {
        viewModel?.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                self?.updateFavoriteButtonAppearance(isFavorite: isFavorite)
            }
            .store(in: &cancellables)
    }
}
