//
//  UpcomingViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private let upcomingTable = UITableView(frame: .zero, style: .plain)
    
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
        upcomingTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        upcomingTable.frame = view.bounds
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: ShowModel(titleName: shows[indexPath.row].original_name ?? shows[indexPath.row].original_title ?? "Unknown" , posterUrl: shows[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPreview(show: shows[indexPath.row]){
            DispatchQueue.main.async {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        }
        
    }
    
    
    
}


extension UpcomingViewController {
    
    func showPreview(show: Show, completion: @escaping () -> ()){
        let title = show.original_title ?? show.original_name ?? "Unknown"
        
        APICaller.shared.getMovie(with: title + " trailer") { [weak self] result in
            guard let self else { return }
            switch result{
            case .success(let videoElement):
                
                DispatchQueue.main.async { [weak self] in
                    let vc = ShowPreviewViewController()
                    vc.configure(with: ShowPreview(title: title, youtubeView: videoElement, titleOverview: show.overview ?? "No overview available"))
                    self?.present(vc, animated: true)
                    completion()
                }
                
            case .failure(let error):
                print("\n Error: \(error.localizedDescription) \n")
            }
        }
        
        
    }
}
