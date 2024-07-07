//
//  MoviesListViewController.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import RxSwift
import RxCocoa
import UIKit

class MoviesListViewController: UIViewController {
    @IBOutlet private var containerStackView: UIStackView!
    @IBOutlet private var collectionView: UICollectionView!
    
    var viewModel: MoviesListViewModel?
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    
    init(viewModel: MoviesListViewModel, nibName: String) {
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
        registerCell()
        fetchNowPlayingMovies()
        configureDataSource()
        setupViewBinding()
        observeFavoriteStatusChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupViews() {
        title = NSLocalizedString("Now Playing", comment: "")
    }
    
    private func fetchNowPlayingMovies() {
        Task {
            do {
                try await viewModel?.loadNowplayingMovies()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupViewBinding() {
        guard let viewModel = viewModel else { return }
        
        viewModel.movies
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                self.snapshot(movies: movies)
            }).disposed(by: disposeBag)
            
        Observable.combineLatest(viewModel.movies.asObservable(), viewModel.isLoading)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _, isLoading in
                guard let self = self else { return }
                self.collectionView.isHidden = isLoading
            }).disposed(by: disposeBag)
    }
    
    private func registerCell() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = MoviesListViewController.generateCollectionLayout()
        collectionView.register(UINib(nibName: MovieCVCell.className, bundle: nil),
                                forCellWithReuseIdentifier: MovieCVCell.className)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Movie>(collectionView: collectionView) { [unowned self] in
            configureCell(collectionView: $0, indexPath: $1, movie: $2)
        }
    }
    
    private func snapshot(movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies, toSection: 0)
        dataSource?.apply(snapshot)
    }
    
    private func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        movie: Movie
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCVCell.className, for: indexPath) as! MovieCVCell
       
        let cellViewModel = MovieCVCellViewModel(movie: movie)
        cell.configure(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    private func observeFavoriteStatusChanges() {
        NotificationCenter.default.rx.notification(.favoriteStatusChanged)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self,
                      let updatedMovie = notification.object as? Movie else { return }
                if let index = self.viewModel?.movies.value.firstIndex(where: { $0.id == updatedMovie.id }) {
                    self.viewModel?.movies.value[index].isFavorite = updatedMovie.isFavorite
                    self.collectionView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
}

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let viewModel = viewModel, let movie = viewModel.selectedMovie(at: indexPath.row) {
            print(movie.isFavorite)
            viewModel.coordinator.goToMovieDetails(movie: movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            if viewModel.movies.value.count > 19 && viewModel.movies.value.count - 1 == indexPath.row {
                viewModel.loadMoreMovies()
            }
        }
    }
}

extension MoviesListViewController: MovieCVCellDelegate {
    func didTapFavoriteButton(in cell: MovieCVCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let movie = viewModel?.movies.value[indexPath.row] {
            viewModel?.toggleFavorite(movie: movie)
            cell.updateFavoriteButtonAppearance(isFavorite: movie.isFavorite)
        }
    }
}
