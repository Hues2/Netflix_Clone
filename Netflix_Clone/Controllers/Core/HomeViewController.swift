//
//  HomeViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit



enum Sections: Int{
    case Trendingmovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {
    
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        
        // MARK: Configure TableView
        configureTableView()
        
        // MARK: Configure Nav Bar
        configureNavBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    
    // MARK: Configure Table View
    private func configureTableView(){
        view.addSubview(homeFeedTable)
        homeFeedTable.frame = view.bounds
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    
    // MARK: Configure Nav Bar
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.changeSize(CGSize(width: 20, height: 35))
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.tintColor = .label
        
    }

   
    
    
    
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count // --> Number of rows in this case. Each row will have its own header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // --> 1 row per section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
            
        }
        
        switch indexPath.section{
            
        case Sections.Trendingmovies.rawValue:
            APICaller.shared.getShows(type: .movie, apiUrl: .TRENDING) { result in
                switch result{
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let apiError):
                    print("\n \(apiError.rawValue) \n")
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getShows(type: .tv, apiUrl: .TRENDING) { result in
                switch result{
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let apiError):
                    print("\n \(apiError.rawValue) \n")
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getShows(type: .movie, apiUrl: .POPULAR) { result in
                switch result{
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let apiError):
                    print("\n \(apiError.rawValue) \n")
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getShows(type: .movie, apiUrl: .UPCOMING) { result in
                switch result{
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let apiError):
                    print("\n \(apiError.rawValue) \n")
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getShows(type: .movie, apiUrl: .TOPRATED) { result in
                switch result{
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let apiError):
                    print("\n \(apiError.rawValue) \n")
                }
            }
        default:
            return UITableViewCell()
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
}



