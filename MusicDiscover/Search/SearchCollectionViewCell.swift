//
//  SearchCollectionViewCell.swift
//  MusicDiscover
//
//  Created by hwanghye on 8/9/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    
    let musicCoverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    let musicNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        
        contentView.addSubview(musicCoverImage)
        contentView.addSubview(musicNameLabel)
        contentView.addSubview(artistNameLabel)
        
        musicCoverImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        musicNameLabel.snp.makeConstraints { make in
            make.top.equalTo(musicCoverImage.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(musicNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    func configure(with result: Result) {
        musicNameLabel.text = result.trackName
        artistNameLabel.text = result.artistName
        
        if let url = URL(string: result.artworkUrl100) {
            musicCoverImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            musicCoverImage.image = UIImage(named: "placeholder")
        }
    }
}
