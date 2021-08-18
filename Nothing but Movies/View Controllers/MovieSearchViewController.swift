//
//  MovieSearchViewController.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 12/08/21.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.dataSource = self
            searchResultTableView.delegate = self
            searchResultTableView.tableFooterView = UIView()  //simple trick to hide extra separator lines
            searchResultTableView.rowHeight = 50
        }
    }
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    lazy var viewModel = MovieSearchViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Movies"
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loaderView.isHidden = true
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            hideLoading()
            viewModel.flush()
            return
        }

        viewModel.getSearchResults(queryString: query)
    }
}

extension MovieSearchViewController: ViewModelProtocol {
    
    func showLoading() {
        loaderView.isHidden = false
        loaderView.startAnimating()
        view.bringSubviewToFront(loaderView)
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loaderView.stopAnimating()
            self?.loaderView.isHidden = true
        }
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.searchResultTableView.reloadData()
        }
    }
    
    func showError(message: String) {
        // show error
    }
}

private typealias SearchBarDelegate = MovieSearchViewController
extension SearchBarDelegate: UISearchBarDelegate, UITextFieldDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar) //throttling the search to improve performance
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.flush()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

private typealias TableViewDelegate = MovieSearchViewController
extension TableViewDelegate: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath)
        cell.textLabel?.text = viewModel.movies[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.searchTextField.endEditing(true)
        
        let movieDetailsVC: MovieDetailsViewController = MovieDetailsViewController(movieId: viewModel.movies[indexPath.row].id)
        movieDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
