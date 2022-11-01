//
//  ShowPreviewViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 01/11/2022.
//

import UIKit
import WebKit

class ShowPreviewViewController: UIViewController {

    
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let downloadButton = UIButton()
    private let webView = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        // MARK: Configure Web View
        configureWebView()
        
        // MARK: Configure Title Label
        configureTitleLabel()
        
        // MARK: Configure Overview Label
        configureOverviewLabel()
        
        // MARK: Configure Download Button
        configureDownloadButton()
        
        
    }
    
    
    // MARK: Configure Title Label
    private func configureTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.text = "Harry Potter"
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
    }
    
    // MARK: Configure OverView
    private func configureOverviewLabel(){
        view.addSubview(overviewLabel)
        overviewLabel.font = .systemFont(ofSize: 18, weight: .regular)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        
        overviewLabel.text = "Best movie ever to watch as a kid or adult."
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    // MARK: Configure Download Button
    private func configureDownloadButton(){
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.backgroundColor = .systemRed
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.setTitle("Download", for: .normal)
        
        downloadButton.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            downloadButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 90),
            downloadButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
    // MARK: Configure Web View
    private func configureWebView(){
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    
    
    public func configure(with model: ShowPreview){
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = model.title
            self?.overviewLabel.text = model.titleOverview
            
            guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
            
            self?.webView.load(URLRequest(url: url))
        }
        
        
    }

}
