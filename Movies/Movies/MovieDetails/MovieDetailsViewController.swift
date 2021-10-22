//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Rajesh Billakanti on 20/10/21.
//

import UIKit
import Combine

final class MovieDetailsViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelT = MovieDetailsViewModel
    var viewModel: MovieDetailsViewModel!
    private var bag: AnyCancellable?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var scoreValue: UILabel!
    @IBOutlet weak var reviewsValue: UILabel!
    @IBOutlet weak var popularityValue: UILabel!
    @IBOutlet weak var directorInfo: UILabel!
    @IBOutlet weak var writerInfo: UILabel!
    @IBOutlet weak var actorInfo: UILabel!
    @IBOutlet weak var category: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        setupBinding()
    }
    
    private func setupBinding() {
        bag = viewModel
            .$detailsRetrieved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detailsRetrieved in
                guard let self = self, detailsRetrieved else { return }
                self.imageView.load(url: URL(string: self.viewModel.details?.poster ?? "")!)
                self.movieTitle.text = self.viewModel.details?.title
                self.year.text = self.viewModel.details?.year
                self.duration.text = self.viewModel.details?.duration
                self.rating.text = self.viewModel.details?.imdbRating
                self.plot.text = self.viewModel.details?.plot
                self.scoreValue.text = self.viewModel.details?.imdbRating
                self.reviewsValue.text = self.viewModel.details?.imdbVotes
                self.popularityValue.text = self.viewModel.details?.metascore
                self.directorInfo.text = self.viewModel.details?.director
                self.writerInfo.text = self.viewModel.details?.writer
                self.actorInfo.text = self.viewModel.details?.actors
                self.category.text = self.viewModel.details?.type.capitalized
            }
    }
    
    private func setupView() {
        self.movieTitle.text = ""
        self.year.text = ""
        self.duration.text = ""
        self.rating.text = ""
        self.plot.text = ""
        self.scoreValue.text = ""
        self.reviewsValue.text = ""
        self.popularityValue.text = ""
        self.directorInfo.text = ""
        self.writerInfo.text = ""
        self.actorInfo.text = ""
        self.category.text = ""
    }
}
