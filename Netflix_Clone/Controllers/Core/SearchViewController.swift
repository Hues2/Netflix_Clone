//
//  SearchViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    private let discoverTable = UITableView(frame: .zero, style: .plain)
    
    private var shows = [Show]()
    
    private let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    

    override func viewDidLoad() {
        super.viewDidLoad()

    
        // MARK: Configure Controller
        configureController()
        
        // MARK: Configure Table
        configureTableView()
        
        // MARK: Configure Search Controller
        configureSearchController()
        
        // MARK: Fetch Data
        fetchDiscover()

        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        discoverTable.frame = view.bounds
        
    }
    
    
    // MARK: Configure Controller
    private func configureController(){
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
    }
    
    
    // MARK: Configure TableView
    private func configureTableView(){
        view.addSubview(discoverTable)
        discoverTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        discoverTable.frame = view.bounds
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
    }
    
    
    // MARK: Configure Search Controller
    private func configureSearchController(){
        searchController.searchBar.placeholder = "Search for a Movie or TV Show"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.tintColor = .systemRed
        searchController.searchResultsUpdater = self
    }
    
    
    
    // MARK: Fetch Data
    private func fetchDiscover(){
        APICaller.shared.getShows(type: .movie, apiUrl: .DISCOVER) { [weak self] result in
            switch result{
                
            case .success(let shows):
                
                self?.shows = shows
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
                
            case .failure(let apiError):
                print("\n \(apiError.rawValue) \n")
            }
        }
    }


}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: ShowViewModel(titleName: shows[indexPath.row].original_name ?? shows[indexPath.row].original_title ?? "Unknown" , posterUrl: shows[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}


extension SearchViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        
        guard let query = searchbar.text, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              query.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        APICaller.shared.search(with: query) { result in
                switch result{
                    case .success(let shows):
                    resultsController.setShows(with: shows)
                    
                case .failure(let error):
                    print("\n Error getting the results back from the given query. Error: \(error.localizedDescription) \n")
                    
                }
        }
    }
}
