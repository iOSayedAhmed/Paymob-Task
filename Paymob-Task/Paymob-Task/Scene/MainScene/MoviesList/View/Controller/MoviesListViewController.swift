//
//  MoviesListViewController.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import UIKit
import Combine

class MoviesListViewController: UIViewController {
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
            var viewModel: MoviesListViewModel?
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    
    
    init(viewModel:MoviesListViewModel,nibName:String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
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
            viewModel.$movies
                .receive(on: DispatchQueue.main)
                .sink {[weak self] movies in
                    guard let self else { return }
                    snapshot(movies: movies)
                }.store(in: &cancellables)
            
                viewModel.$movies
                    .combineLatest(viewModel.$isLoading)
                    .receive(on: DispatchQueue.main)
                    .sink {[weak self] movies, isLoading in
                        guard let self else { return }
                        collectionView.isHidden = isLoading
                    }.store(in: &cancellables)
    }
    
    private func registerCell() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = generateCollectionLayout()
        collectionView.register(UINib(nibName: MovieCVCell.className, bundle: nil),
                                forCellWithReuseIdentifier: MovieCVCell.className)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Movie>(collectionView: collectionView) {[unowned self] in
            return configureCell(collectionView: $0, indexPath: $1, movie: $2)
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
        
        return cell
    }
    
    private func generateCollectionLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/6))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let movie = viewModel?.selectedMovie(at: indexPath.row) {
//            let vm = MovieDetailsViewModel(movie: movie)
//            let vc = MovieDetailsViewController(viewModel: vm)
//            show(vc, sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            if viewModel.movies.count > 19 && viewModel.movies.count - 1 == indexPath.row {
                viewModel.loadMoreMovies()
            }
        }
        
    }
}
