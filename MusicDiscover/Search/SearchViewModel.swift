//
//  SearchViewModel.swift
//  MusicDiscover
//
//  Created by hwanghye on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    let disposeBag = DisposeBag()
    
    private let musicList = Observable.just(["테스트1", "테스트2", "테스트3", "테스트4", "테스트5", "테스트6", "테이블7"])
    
    struct Input {
        let searchText: ControlProperty<String> //searchBar.rx.text.orEmpty
        let searchButtonTap: ControlEvent<Void> //searchBar.rx.searchButtonClicked
    }
    
    struct Output {
        let musicList: Observable<[String]>
    }
    
    func transform(input: Input) -> Output {
        input.searchButtonTap
            .subscribe(with: self) { owner, _ in
                print("tab")
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("viewModel \(value)")
            }
            .disposed(by: disposeBag)


        return Output(musicList: musicList)
    }
}
