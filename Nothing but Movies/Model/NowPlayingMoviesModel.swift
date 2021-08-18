//
//  NowPlayingApiResponseModel.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import Foundation

public struct MoviesModel {
    
    public struct Response: Codable {
        let page: Int
        let results: [MovieInfoModel]?
        let totalPages: Int?
        let totalResults: Int?
    }
    
    public struct MovieInfoModel: Codable {
        let id: Int
        let posterPath: String?
        let releaseDate: String?
        let voteAverage: Float?
        let popularity: Float?
        let title: String?
        let overview: String?
    }
}


