//
//  NetworkService.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import Foundation

public typealias FetchNowPlayingMoviesCompletionHandler = (Result<MoviesModel.Response, Error>) -> Void
public typealias FetchMovieDetailsCompletionHandler = (Result<MovieDetailsModel.MovieDetails, Error>) -> Void
public typealias FetchSearchedMoviesCompletionHandler = (Result<MoviesModel.Response, Error>) -> Void


class NetworkService {
    private let session: URLSession
    private let apiKey: String = "4e4a0cd6f91ddf642625818cf51c5a00"
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        session = URLSession.init(configuration: config)
    }
    
    func getNowPlayingMoviesFromNetwork(page: Int, completionHandler: @escaping FetchNowPlayingMoviesCompletionHandler) {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=\(page)") {
            let task = session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print("An Error Occured \(err.localizedDescription)")
                    completionHandler(.failure(err))
                    return
                }
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedNowPlayingModel = try decoder.decode(MoviesModel.Response.self, from: jsonData)
                        completionHandler(.success(decodedNowPlayingModel))
                    } catch {
                        completionHandler(.failure(error))
                        print("JSON error: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func getMovieDetailsFromNetwork(movieId: Int, completionHandler: @escaping FetchMovieDetailsCompletionHandler) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)&language=en-US") else {
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            if let jsonData = data {
                do {
                    let decodedModel = try JSONDecoder().decode(MovieDetailsModel.MovieDetails.self, from: jsonData)
                    completionHandler(.success(decodedModel))
                } catch {
                    completionHandler(.failure(error))
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            
        })
        task.resume()
    }
    
    func getSearchedMovieListFromNetwork(query: String, completionHandler: @escaping FetchSearchedMoviesCompletionHandler) {
        if let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)&page=1") {
            let task = session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print("An Error Occured \(err.localizedDescription)")
                    completionHandler(.failure(err))
                    return
                }
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedNowPlayingModel = try decoder.decode(MoviesModel.Response.self, from: jsonData)
                        completionHandler(.success(decodedNowPlayingModel))
                    } catch {
                        completionHandler(.failure(error))
                        print("JSON error: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
}
