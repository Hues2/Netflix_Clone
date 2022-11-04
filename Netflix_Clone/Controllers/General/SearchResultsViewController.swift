//
//  SearchResultsViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 01/11/2022.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private var shows = [Show]()

    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        // MARK: Configure Collection View
        configureCollection()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
    }
    
    
    // MARK: Configure CollectionView
    private func configureCollection(){
        view.addSubview(collectionView)
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    // MARK: Set Shows
    public func setShows(with shows: [Show]){
        self.shows = shows
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    

}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as? ShowCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        cell.layer.cornerRadius = 8
        cell.makeRoundedCorners()
        
        if let posterPath = shows[indexPath.row].poster_path{
            cell.configure(with: posterPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showPreview(show: shows[indexPath.row]){
            DispatchQueue.main.async {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
            
        }
    }
    
    
    
}


extension SearchResultsViewController{
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
