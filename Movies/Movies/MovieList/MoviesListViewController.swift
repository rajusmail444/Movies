//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//
import UIKit
import Combine

final class MoviesListViewController: UICollectionViewController {
    private var viewModel: MoviesListViewModel!
    private lazy var dataSource = makeDataSource()
    private var searchController = UISearchController(searchResultsController: nil)
    private var bag: AnyCancellable?
    private var loadingView: LoadingIndicatorView?
    private var isLoading = false
    private var filteredQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MoviesListViewModel(serviceWrapper: ServiceWrapper())
        setupBackground()
        setupTitle()
        configureSearchController()
        configureLayout()
        setupBinding()
        viewModel.fetch(movie: "Marvel")
    }
    
    private func setupBackground() {
        view.backgroundColor = .systemBackground
        self.collectionView.backgroundColor = .clear
    }
    
    private func setupTitle() {
        self.title = viewModel.title
    }
    
    private func setupBinding() {
        bag = viewModel.$moviesCount
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] moviesCount in
                guard let self = self else { return }
                self.isLoading = false
                self.applySnapshot(self.viewModel.movies)
            }
    }
    
    func applySnapshot(_ movies: [Movie], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
//        collectionView.reloadData()
    }
}

private extension MoviesListViewController {
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: cellProviderBuilder()
        )
        dataSource.supplementaryViewProvider = makeSupplementaryViewProvider()
        return dataSource
    }
    
    private func cellProviderBuilder() -> DataSource.CellProvider {
        { (collectionView, indexPath, movie) ->
            UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MovieCollectionViewCell",
                for: indexPath) as? MovieCollectionViewCell
            cell?.movie = movie
            return cell
        }
    }
    
    private func makeSupplementaryViewProvider() -> DataSource.SupplementaryViewProvider {
        { [weak self] collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionFooter:
                let aFooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: LoadingIndicatorView.reuseIdentifier,
                    for: indexPath
                ) as? LoadingIndicatorView
                self?.loadingView = aFooterView
                self?.loadingView?.backgroundColor = .clear
                return aFooterView
            default:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: EmptyReusableView.reuseIdentifier,
                    for: indexPath
                ) as? EmptyReusableView
            }
        }
    }
}

// MARK: - UICollectionViewDataSource Implementation
extension MoviesListViewController {
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        let viewModel = MovieDetailsViewModel(imdbID: movie.imdbID, serviceWrapper: ServiceWrapper())
        
        let viewController = UIViewController.make(
            viewController: MovieDetailsViewController.self,
            viewModel: viewModel
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let movies = filteredSection(for: searchController.searchBar.text)
        applySnapshot(movies)
    }
    
    func filteredSection(for queryOrNil: String?) -> [Movie] {
        let movies = viewModel.movies
        guard
            let query = queryOrNil
        else {
            print("Query is empty")
            return movies
        }
        if query.isEmpty {
            viewModel.fetch(movie: "Marvel")
            return movies
        }
        let filteredMovies = movies.filter {
            $0.title.lowercased().contains(query.lowercased())
        }
        viewModel.movies = []
        self.filteredQuery = query
        let movie = self.filteredQuery.count > 0 ? self.filteredQuery : "Marvel"
        if movie.count > 2 {
            self.isLoading = true
            viewModel.fetch(movie: movie)
        }
        return filteredMovies
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension MoviesListViewController {
    private func configureLayout() {
        collectionView.register(
            EmptyReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmptyReusableView.reuseIdentifier
        )
        collectionView.register(
            LoadingIndicatorView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingIndicatorView.reuseIdentifier
        )
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
                let size = NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                    heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
                )
                let itemCount = isPhone ? 2 : 3
                let item = NSCollectionLayoutItem(layoutSize: size)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 10
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(20)
                )
                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(50)
                )
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )
                section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
                return section
            })
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

extension MoviesListViewController {
    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        if elementKind == UICollectionView.elementKindSectionFooter
            && self.viewModel.page + 1 <= self.viewModel.totalresults/10 {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        at indexPath: IndexPath
    ) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.moviesCount - 1 && !self.isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            self.loadingView?.activityIndicator.stopAnimating()
            DispatchQueue.global().async {
                sleep(2)
                let page = self.viewModel.page + 1
                let movie = self.filteredQuery.count > 0 ? self.filteredQuery : "Marvel"
                if page <= self.viewModel.totalresults/10 && movie.count > 2 {
                    self.viewModel.fetch(movie: movie, page: page)
                } else {
                    DispatchQueue.main.async {
                        self.loadingView?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
