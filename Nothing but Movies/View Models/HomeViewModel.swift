//
//  HomeViewModel.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import Foundation

class HomeViewModel {
    
    private(set) var nowPlayingMovies: [MoviesModel.MovieInfoModel] = []
    private lazy var networkManager: NetworkService = {
        return NetworkService()
    }()
    private(set) var currentPage: Int = 0
    private(set) var totalPages: Int = 0
    private weak var delegate: ViewModelProtocol?
    
    init(delegate: ViewModelProtocol) {
        self.delegate = delegate
    }
    
    func fetchNowPlayingMovies(isPaginationEnabled: Bool = false) {
        delegate?.showLoading()
        let pageNumber: Int = isPaginationEnabled ? (currentPage + 1) : 1
        networkManager.getNowPlayingMoviesFromNetwork(page: pageNumber, completionHandler: { [weak self] result in
            self?.delegate?.hideLoading()
            switch result {
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            case .success(let nowPlayingMovies):
                guard let movies = nowPlayingMovies.results, !movies.isEmpty else {
                    self?.delegate?.showError(message: "No movies to show right now.")
                    return
                }
                self?.totalPages = nowPlayingMovies.totalPages ?? 0
                self?.currentPage = nowPlayingMovies.page
                self?.nowPlayingMovies.append(contentsOf: movies)
                self?.delegate?.updateView()
            }
        })
    }
}
