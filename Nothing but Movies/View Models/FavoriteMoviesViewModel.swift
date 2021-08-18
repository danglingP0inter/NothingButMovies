//
//  FavoriteMoviesViewModel.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 14/08/21.
//

import Foundation

class FavoriteMoviesViewModel {
    
    private(set) var favoriteMovies: [MovieDetailsModel.MovieDetails] = []
    private weak var delegate: ViewModelProtocol?
    
    init(delegate: ViewModelProtocol) {
        self.delegate = delegate
    }
    
    func fetchFavoriteMovies() {
        if Storage.fileExists("favorites.json", in: .caches) {
            favoriteMovies = Storage.retrieve("favorites.json", from: .caches, as: [MovieDetailsModel.MovieDetails].self)
            delegate?.updateView()
        }
    }
}
