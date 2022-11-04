//
//  CollectionViewTableViewCell.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit


protocol CollectionViewTableViewCellDelegate: AnyObject{
    func collectionViewTableViewCellDidTapCell(model: ShowPreview)
}



class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    private let collectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    private var shows = [Show]()
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        configureCollectionView()
        
    }
    
    // MARK: Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    // MARK: Configure the CollectionView
    private func configureCollectionView(){
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Configure
    public func configure(with shows: [Show]){
        self.shows = shows
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
    
    private func downloadTitleAt(show: Show){
        print("\n Donwloading  \(show.original_name ?? show.original_title ?? "Unknown")... \n")
        
        DataPersistenceManager.shared.downloadShowWith(show: show) { result in
            switch result{
            case .success(_ ):
                print("\n Downloaded to database \n")
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                
            case .failure(let error):
                print("\n Failed  \n")
            }
        }
        
    }
    

}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as? ShowCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let image = shows[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        
        cell.configure(with: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let title = shows[indexPath.row].original_title ?? shows[indexPath.row].original_name else { return }
        
        APICaller.shared.getMovie(with: title + " trailer") { [weak self] result in
            guard let self else { return }
            switch result{
            case .success(let videoElement):
                
                self.delegate?.collectionViewTableViewCellDidTapCell(model: ShowPreview(title: title, youtubeView: videoElement, titleOverview: self.shows[indexPath.row].overview ?? "No overview available."))
                                
            case .failure(let error):
                print("\n Error: \(error.localizedDescription) \n")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ [weak self] _ in
            
            guard let self else { return UIMenu()}
            
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil) { _ in
                self.downloadTitleAt(show: self.shows[indexPath.row])
            }
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            return menu
        }
        
        return config
        
    }
    
}
