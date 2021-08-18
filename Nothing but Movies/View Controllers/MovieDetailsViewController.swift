//
//  MovieDetailsViewController.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var headerImageView: UIImageView! {
        didSet {
            headerImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    private var movieId: Int
    private lazy var viewModel: MovieDetailsViewModel = MovieDetailsViewModel(delegate: self)
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped)), animated: true)
        viewModel.fetchMovieDetails(movieId: movieId)
    }
    
    @objc func shareTapped() {
        if let name = URL(string: "nothingbutmovies://movie_id=\(movieId)"), !name.absoluteString.isEmpty {
            let objectsToShare: [Any] = ["Hey! Look at this really cool movie on Nothing but Movies", name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addToFavoritesTapped(_ sender: Any) {
        viewModel.addToFavoritesAction()
    }
}

extension MovieDetailsViewController: ViewModelProtocol {
    func showLoading() {
        loaderView.startAnimating()
        loaderView.isHidden = false
    }
    
    func hideLoading() {
        loaderView.stopAnimating()
        loaderView.isHidden = true
    }
    
    func updateView() {
        guard let details = viewModel.movieDetails else {
            return
        }
        if let posterUrlString = details.posterPath {
            headerImageView.loadImage(withUrl: posterUrlString)
        }
        titleLabel.text = details.title
        taglineLabel.text = details.tagline
        genreLabel.text = viewModel.genreText
        releaseDateLabel.text = viewModel.releaseDateText
        ratingLabel.text = viewModel.ratingText
        runtimeLabel.text = viewModel.runtimeText
        languageLabel.text = viewModel.languagesText
        synopsisLabel.text = viewModel.synopsisText
        !viewModel.isFavorite ? addToFavoritesButton.setTitle("Add To Favorites", for: .normal) : addToFavoritesButton.setTitle("Added To Favorites", for: .normal)
        !viewModel.isFavorite ? addToFavoritesButton.setImage(UIImage(systemName: "plus"), for: .normal) : addToFavoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func showError(message: String) {
        print(message)
        //show error here
    }
}
