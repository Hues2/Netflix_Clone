//
//  DownloadsViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit

class DownloadsViewController: UIViewController {

    private let downloadsTable = UITableView(frame: .zero, style: .plain)
    
    private var shows = [ShowItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: Configure Controller
        configureController()
        
        // MARK: Configure TableView
        configureTableView()
        
        // MARK: Fetch Shows
        fetchShows()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchShows()
        }
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // MARK: Fetch Shows
//        fetchShows()
    }

    // MARK: Configure Controller
    private func configureController(){
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    // MARK: Configure TableView
    private func configureTableView(){
        view.addSubview(downloadsTable)
        downloadsTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        downloadsTable.frame = view.bounds
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
    
    
    private func fetchShows(){
        DataPersistenceManager.shared.fetchShowsFromDatabase { result in
            switch result{
            case .success(let shows):
                self.shows = shows
                DispatchQueue.main.async { [weak self] in
                    self?.downloadsTable.reloadData()
                }
                
            case .failure(let error):
                print("\n Error fetching shows from core data. \(error.localizedDescription) \n")
            }
        }
    }
   

}


extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource{
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            DataPersistenceManager.shared.deleteShowWith(show: shows[indexPath.row]) { [weak self] result in
                guard let self else { return }
                switch result{
                case .success():
                    print("\n Deleted Successfully \n")
                    self.shows.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    
                case .failure(let error):
                    print("\n Error deleting from core data. \(error.localizedDescription) \n")
                }
            }
            
        default:
            break
        }
    }
 
}


extension DownloadsViewController {
    
    func showPreview(show: ShowItem, completion: @escaping () -> ()){
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
