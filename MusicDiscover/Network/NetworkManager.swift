//
//  NetworkManager.swift
//  MusicDiscover
//
//  Created by hwanghye on 8/11/24.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class NetworkManager {
    
    static let shared = NetworkManager() //전역에 할당?
    private init() { } //또 다른 인스턴스 생성하지 못하게 강제
    
    func callMusic(searchText: String) -> Observable<Welcome> {
        let url = "\(APIURL.baseURL)term=\(searchText)"
        
        let result = Observable<Welcome>.create { observer in
            
            guard let url = URL(string: url) else {
                
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                if let error = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as?
                        HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                //print(url)
                //print(String(data: data!, encoding: String.Encoding.utf8) as String?)
                if let data = data,
                   let appData = try?
                    JSONDecoder().decode(Welcome.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted() //알아서 dispose 될 수 있는 환경으로 만들기
                } else {
                    print("응답은 왔으나 디코딩 실패")
                    observer.onError(APIError.unknownResponse)
                }
                
            }.resume()
            
            return Disposables.create()
        }
            .debug("박스 오피스조회")
        return result
    }
}
