//
//  ShowCollectionViewCell.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 26/10/2022.
//

import UIKit
import SDWebImage

class ShowCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ShowCollectionViewCell"
    
    private let posterImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: Configure Cell Image
        configureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Configure Image
    private func configureImage(){
        contentView.addSubview(posterImageView)
        posterImageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    
    
    public func configure(with model: String){
        guard let url = URL(string: Constants.baseImageURL + model) else { return }
        
        // Save in cache
        posterImageView.sd_setImage(with: url)
    }
    
    
    
    
}
