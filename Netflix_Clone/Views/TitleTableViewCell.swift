//
//  TitleTableViewCell.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 01/11/2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let showImage = UIImageView()
    
    private let showLabel = UILabel()
    
    private let playButton = UIButton()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        // MARK: Configure Image
        configureImage()
        
        // MARK: Configure Label
        configureLabel()
        
        // MARK: Configure Button
        configureButton()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    
    // MARK: Configure Image
    private func configureImage(){
        contentView.addSubview(showImage)
        showImage.contentMode  = .scaleAspectFill
        showImage.translatesAutoresizingMaskIntoConstraints = false
        showImage.clipsToBounds = true
        showImage.layer.cornerRadius = 10
        
        
        NSLayoutConstraint.activate([
            showImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            showImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            showImage.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    // MARK: Configure Label
    private func configureLabel(){
        contentView.addSubview(showLabel)
        showLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showLabel.leadingAnchor.constraint(equalTo: showImage.trailingAnchor, constant: 20),
            showLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

    }
    
    
    // MARK: Configure Button
    private func configureButton(){
        contentView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        playButton.setImage(buttonImage, for: .normal)
        playButton.tintColor = .label
        
        
        NSLayoutConstraint.activate([
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    
    public func configureCell(with show: ShowViewModel){
        guard let url = URL(string: Constants.baseImageURL + show.posterUrl) else { return }
        
        self.showImage.sd_setImage(with: url)
        self.showLabel.text = show.titleName
    }
    

}
