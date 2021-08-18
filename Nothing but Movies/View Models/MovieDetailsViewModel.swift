//
//  MovieDetailsViewModel.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import Foundation

class MovieDetailsViewModel {
    
    private lazy var networkManager: NetworkService = {
        return NetworkService()
    }()
    private weak var delegate: ViewModelProtocol?
    
    private(set) var movieDetails: MovieDetailsModel.MovieDetails?
    private(set) var isFavorite = false
    
    var genreText: String? {
        if let genres = movieDetails?.genres?.compactMap({ $0.name }), !genres.isEmpty {
            return "Genre: \(genres.joined(separator: ", "))"
        }
        
        return nil
    }
    
    var releaseDateText: String? {
        if let releaseDate = movieDetails?.releaseDate {
            return "Release Date: \(releaseDate)"
        }
        
        return nil
    }
    
    var ratingText: String? {
        if let averageRating = movieDetails?.voteAverage {
            return "Average Rating: \(averageRating)/10"
        }
        
        return nil
    }
    
    var runtimeText: String? {
        if let runtime = movieDetails?.runtime {
            return "Runtime: \(runtime) mins."
        }
        
        return nil
    }
    
    var languagesText: String? {
        if let languages = movieDetails?.spokenLanguages?.compactMap({ $0.name }), !languages.isEmpty {
            return "Language: \(languages.joined(separator: ", "))"
        }
        
        return nil
    }
    
    var synopsisText: String? {
        if let synopsis = movieDetails?.overview {
            return "Synopsis: \(synopsis)"
        }
        
        return nil
    }
    
    init(delegate: ViewModelProtocol) {
        self.delegate = delegate
    }
    
    func fetchMovieDetails(movieId: Int) {
        delegate?.showLoading()
        networkManager.getMovieDetailsFromNetwork(movieId: movieId, completionHandler: { [weak self] result in
            DispatchQueue.main.async {
                self?.delegate?.hideLoading()
                switch result {
                case .failure(let error):
                    self?.delegate?.showError(message: error.localizedDescription)
                case .success(let details):
                    self?.movieDetails = details
                    self?.updateIsFavorite(movieId: movieId)
                    self?.delegate?.updateView()
                }
            }
        })
    }
    
    private func updateIsFavorite(movieId: Int) {
        if Storage.fileExists("favorites.json", in: .caches) {
            let favorites = Storage.retrieve("favorites.json", from: .caches, as: [MovieDetailsModel.MovieDetails].self)
            isFavorite = favorites.contains(where: { $0.id == movieId })
        } else {
            isFavorite = false
        }
    }
    
    func addToFavoritesAction() {
        guard let movieDetails = movieDetails else {
            return
        }
        
        var favorites: [MovieDetailsModel.MovieDetails] = []
        if Storage.fileExists("favorites.json", in: .caches) {
            favorites = Storage.retrieve("favorites.json", from: .caches, as: [MovieDetailsModel.MovieDetails].self)
        }
        
        if let index = favorites.firstIndex(where: { $0.id == movieDetails.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(movieDetails)
        }
        
        Storage.store(favorites, to: .caches, as: "favorites.json")
        updateIsFavorite(movieId: movieDetails.id)
        delegate?.updateView()
    }
}
