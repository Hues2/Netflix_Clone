//
//  HeroHeaderUIView.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    private let playButton = UIButton()
    
    private let downloadButton = UIButton()

    
    private let heroImageView: UIImageView = {
       
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        
        return imageView
        
    }()

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImage()
        configurePlayButton()
        configureDownloadButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    
    // MARK: Configure the image view
    private func configureImage(){
        addSubview(heroImageView)
        addGradient()
    }
    
    // MARK: Fade gradient
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    // MARK: Configure Play Button
    private func configurePlayButton(){
        addSubview(playButton)
        playButton.setTitle("Play", for: .normal)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.cornerRadius = 10
        playButton.layer.borderWidth = 1
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    // MARK: Configure Download Button
    private func configureDownloadButton(){
        addSubview(downloadButton)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.cornerRadius = 10
        downloadButton.layer.borderWidth = 1
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    
    
}
