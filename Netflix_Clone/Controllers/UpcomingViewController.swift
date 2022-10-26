//
//  UpcomingViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private let upcomingTable = UITableView()
    
    private var shows = [Show]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: Configure Controller
        configureController()
        
        // MARK: Configure TableView
        configureTableView()
        
        // MARK: Fetch Upcoming
        fetchUpcoming()
    }
    

    // MARK: Configure Controller
    private func configureController(){
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    // MARK: Configure TableView
    private func configureTableView(){
        view.addSubview(upcomingTable)
        upcomingTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
    private func fetchUpcoming(){
        APICaller.shared.getShows(type: .movie, apiUrl: .UPCOMING) { [weak self] result in
            switch result{
                
            case .success(let shows):
                
                self?.shows = shows
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
                
            case .failure(let apiError):
                print("\n \(apiError.rawValue) \n")
            }
        }
    }
    
  

}



extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shows[indexPath.row].original_name ?? shows[indexPath.row].original_title ?? ""
        return cell
    }
    
    
}
