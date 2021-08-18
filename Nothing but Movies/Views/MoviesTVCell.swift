//
//  MoviesTVCell.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import UIKit

class MoviesTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView! {
        didSet {
            movieImageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var summaryLabel: UILabel!
    
    private var movie: MoviesModel.MovieInfoModel?
    
    func configure(movie: MoviesModel.MovieInfoModel) {
        self.movie = movie
        
        movieImageView.loadImage(withUrl: movie.posterPath ?? "")
        titleLabel.text = movie.title
        summaryLabel.text = movie.overview
    }
}
