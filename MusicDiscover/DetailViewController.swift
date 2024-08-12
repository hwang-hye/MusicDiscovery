//
//  DetailViewController.swift
//  MusicDiscover
//
//  Created by hwanghye on 8/12/24.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    
    private let musicCoverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(result: Result) {
        super.init(nibName: nil, bundle: nil)
        configure(with: result)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(musicCoverImage)
        view.addSubview(trackNameLabel)
        view.addSubview(artistNameLabel)
        
        musicCoverImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.top.equalTo(musicCoverImage.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(trackNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func configure(with result: Result) {
        trackNameLabel.text = result.trackName
        artistNameLabel.text = result.artistName
        
        if let url = URL(string: result.artworkUrl100) {
            musicCoverImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            musicCoverImage.image = UIImage(named: "placeholder")
        }
    }
}
