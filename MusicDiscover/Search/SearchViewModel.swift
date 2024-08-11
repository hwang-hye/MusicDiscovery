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
    
    private let musicListSubject = PublishSubject<[Result]>()
    
    struct Input {
        let searchText: ControlProperty<String> //searchBar.rx.text.orEmpty
        let searchButtonTap: ControlEvent<Void> //searchBar.rx.searchButtonClicked
    }
    
    struct Output {
        let musicList: Observable<[Result]>
    }
    
    func transform(input: Input) -> Output {
        let musicList = PublishSubject<[Result]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
        //.map { //searchText 문자열 인코딩 처리 로직 작성하기 }
            .flatMapLatest { value -> Observable<[Result]> in
                return NetworkManager.shared.callMusic(searchText: value)
                    .map { result in
                        return result.results // `Result`를 `[Result]`로 변환
                    }
                    .catchAndReturn([]) // 오류 발생 시 빈 배열 반환
            }
            .subscribe(onNext: { music in
                print("tab")
                musicList.onNext(music) // 결과를 PublishSubject에 전달
            }, onError: { error in
                print("error \(error)")
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("viewModel \(value)")
            }
            .disposed(by: disposeBag)
        
        return Output(musicList: musicList)
    }
}
