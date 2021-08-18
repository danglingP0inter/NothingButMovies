//
//  DataStore.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 13/08/21.
//

import UIKit

class DataStore {
    
    private lazy var networkManager: NetworkService = {
        return NetworkService()
    }()
    
    func getNowPlayingMovies(page: Int, completionHandler: @escaping FetchNowPlayingMoviesCompletionHandler) {
        
        
    }
}
