//
//  SearchViewController.swift
//  MusicDiscover
//
//  Created by hwanghye on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4 //아이템좌우
        layout.minimumLineSpacing = 4 //아이템상하
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let musicList = Observable.just(["테스트1", "테스트2", "테스트3"])
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    func bind() {
        musicList
            .bind(to: collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) {
                (row, element, cell) in
                
                cell.musicNameLabel.text = element
            }
            .disposed(by: disposeBag)
        
        //RxCocoa는 내부적으로 UICollectionView의 delegate와 dataSource를 관리
        //이를 수동으로 설정하는 경우 충돌이 발생
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        navigationItem.titleView = searchBar
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}


extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20 // 예시로 20개의 셀을 표시
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 12 // 좌우 여백 각 4씩, 중앙 여백 4
        let numberOfItemsPerRow: CGFloat = 2 //한줄 셀의 개수
        let availableWidth = collectionView.bounds.width - totalSpacing
        let width =  availableWidth / numberOfItemsPerRow
        let height = width * 4 / 3 // 3:4 비율
        return CGSize(width: width, height: height)
    }
}

