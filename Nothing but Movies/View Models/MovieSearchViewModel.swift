//
//  MovieSearchViewModel.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 12/08/21.
//

import Foundation


class MovieSearchViewModel {
    
    private lazy var networkManager: NetworkService = {
        return NetworkService()
    }()
    
    private weak var delegate: ViewModelProtocol?
    private(set) var movies: [MoviesModel.MovieInfoModel] = []
    
    init(delegate: ViewModelProtocol) {
        self.delegate = delegate
    }
    
    func flush() {
        movies.removeAll()
        delegate?.updateView()
    }
    
    func getSearchResults(queryString: String) {
        delegate?.showLoading()
        networkManager.getSearchedMovieListFromNetwork(query: queryString, completionHandler: { [weak self] result in
            self?.delegate?.hideLoading()
            switch result {
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            case .success(let searchResult):
                guard let movies = searchResult.results, !movies.isEmpty else {
                    return
                }
                self?.movies = movies
                self?.delegate?.updateView()
            }
        })
    }
}
