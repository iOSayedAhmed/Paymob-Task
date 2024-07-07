//
//  FavoritesMoviesViewController.swift
//  Paymob-Task
//
//  Created by iOSAYed on 07/07/2024.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesMoviesViewController: UIViewController {
    @IBOutlet private var containerStackView: UIStackView!
    @IBOutlet private var collectionView: UICollectionView!
    
    private var emptyView: UILabel!
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    var viewModel: FavoritesMoviesViewModel?
    
    init(viewModel: FavoritesMoviesViewModel, nibName: String) {
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
        setupEmptyView()
        registerCell()
        configureDataSource()
        setupViewBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViews() {
        title = NSLocalizedString("Favorites", comment: "")
    }
    
    private func setupEmptyView() {
        emptyView = UILabel()
        emptyView.text = NSLocalizedString("No favorites yet", comment: "")
        emptyView.textAlignment = .center
        emptyView.textColor = .gray
        emptyView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyView.isHidden = true
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewBinding() {
        guard let viewModel = viewModel else { return }
        
        viewModel.favoriteMovies
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                self.emptyView.isHidden = !movies.isEmpty
                self.snapshot(movies: movies)
            })
            .disposed(by: disposeBag)
    }
    
    private func registerCell() {
        collectionView.collectionViewLayout = FavoritesMoviesViewController.generateCollectionLayout()
        collectionView.register(UINib(nibName: FavoriteCVCell.className, bundle: nil),
                                forCellWithReuseIdentifier: FavoriteCVCell.className)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCVCell.className, for: indexPath) as! FavoriteCVCell
       
        let cellViewModel = FavoriteCVCellViewModel(movie: movie)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
}
