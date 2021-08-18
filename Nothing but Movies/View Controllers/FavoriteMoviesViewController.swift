//
//  FavoriteMoviesViewController.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 14/08/21.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {

    @IBOutlet weak var favoriteMoviesTableView: UITableView! {
        didSet {
            favoriteMoviesTableView.dataSource = self
            favoriteMoviesTableView.delegate = self
            favoriteMoviesTableView.tableFooterView = UIView()
            favoriteMoviesTableView.rowHeight = 200
        }
    }
    
    lazy var viewModel = FavoriteMoviesViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchFavoriteMovies()
    }

}

extension FavoriteMoviesViewController: ViewModelProtocol {
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.favoriteMoviesTableView.reloadData()
        }
    }
    
    func showError(message: String) {
        // show error
    }
}

extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath)
        cell.textLabel?.text = viewModel.favoriteMovies[indexPath.row].title
        cell.detailTextLabel?.text = viewModel.favoriteMovies[indexPath.row].overview
        cell.imageView?.loadImage(withUrl: viewModel.favoriteMovies[indexPath.row].posterPath!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieDetailsVC: MovieDetailsViewController = MovieDetailsViewController(movieId: viewModel.favoriteMovies[indexPath.row].id)
        movieDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
