//
//  SearchCollectionViewCell.swift
//  MusicDiscover
//
//  Created by hwanghye on 8/9/24.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    
    let musicCoverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .gray
        image.layer.cornerRadius = 8
        return image
    }()
    
    let musicNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "musiclabel"
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
        contentView.backgroundColor = .lightGray
        
        contentView.addSubview(musicCoverImage)
        contentView.addSubview(musicNameLabel)
        
        musicCoverImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.8)
            
        }
        
        musicNameLabel.snp.makeConstraints { make in
            make.top.equalTo(musicCoverImage.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
    }
}



