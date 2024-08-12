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


//현재는 띄어쓰기 없는 단어만 검색가능
//ex) BTS, Lisa...
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
    
    let viewModel = SearchViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    func bind() {

        let input = SearchViewModel.Input(
            searchText: searchBar.rx.text.orEmpty,
            searchButtonTap: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.musicList
            .bind(to: collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(
            collectionView.rx.modelSelected(Result.self),
            collectionView.rx.itemSelected
        )
        .subscribe(onNext: { [weak self] (result, indexPath) in
            let detailVC = DetailViewController(result: result)
            self?.navigationController?.pushViewController(detailVC, animated: true)
        })
        .disposed(by: disposeBag)
//        output.musicList
//            .bind(to: collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) {
//                (row, element, cell) in
//
//                cell.musicNameLabel.text = element.artistName
//            }
//            .disposed(by: disposeBag)
        
//        Observable.zip(
//            collectionView.rbtsx.modelSelected(String.self),
//            collectionView.rx.itemSelected
//        )
//        .map { "검색어는 \($0.0)" }
//        .subscribe(with: self) { owner, value in
//            print(value)
//        }
//        .disposed(by: disposeBag)
        
        //RxCocoa는 내부적으로 UICollectionView의 delegate와 dataSource를 관리
        //이를 수동으로 설정하는 경우 충돌이 발생?
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        navigationItem.titleView = searchBar
        
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

