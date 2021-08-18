//
//  HomeViewController.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView! {
        didSet {
            moviesTableView.dataSource = self
            moviesTableView.delegate = self
            moviesTableView.register(UINib(nibName: String(describing: MoviesTVCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoviesTVCell.self))
            moviesTableView.rowHeight = 200
        }
    }
    lazy var viewModel = HomeViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Now playing"
        
        viewModel.fetchNowPlayingMovies()
    }
}

extension HomeViewController: ViewModelProtocol {
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.moviesTableView.reloadData()
        }
    }
    
    func showError(message: String) {
        // show error
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MoviesTVCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTVCell.self), for: indexPath) as! MoviesTVCell
        cell.configure(movie: viewModel.nowPlayingMovies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == viewModel.nowPlayingMovies.count) && (viewModel.currentPage != viewModel.totalPages) {
            viewModel.fetchNowPlayingMovies(isPaginationEnabled: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieDetailsVC: MovieDetailsViewController = MovieDetailsViewController(movieId: viewModel.nowPlayingMovies[indexPath.row].id)
        movieDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
