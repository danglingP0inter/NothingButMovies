//
//  MovieDetailsModel.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import Foundation


import Foundation

// MARK: - MovieDetails
public struct MovieDetailsModel {
    public struct MovieDetails: Codable {
        let isAdult: Bool?
        let backdropPath: String?
        let budget: Int?
        let genres: [Genre]?
        let homepage: String?
        let id: Int
        let imdbID, originalLanguage, originalTitle, overview: String?
        let popularity: Double?
        let posterPath: String?
        let releaseDate: String?
        let revenue, runtime: Int?
        let spokenLanguages: [SpokenLanguage]?
        let status, tagline, title: String?
        let video: Bool?
        let voteAverage: Double?
        let voteCount: Int?

        enum CodingKeys: String, CodingKey {
            case isAdult
            case backdropPath = "backdrop_path"
            case budget, genres, homepage, id
            case imdbID = "imdb_id"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case revenue, runtime
            case spokenLanguages = "spoken_languages"
            case status, tagline, title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }

    // MARK: - Genre
    public struct Genre: Codable {
        let id: Int?
        let name: String?
    }


    // MARK: - SpokenLanguage
    public struct SpokenLanguage: Codable {
        let englishName, iso639_1, name: String?

        enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case iso639_1 = "iso_639_1"
            case name
        }
    }
}

