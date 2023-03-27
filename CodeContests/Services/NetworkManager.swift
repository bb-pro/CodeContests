//
//  NetworkManager.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 27/03/23.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchContests(from url: URL, completion: @escaping(Result<[Contest], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let contests = Contest.getContests(from: value)
                    completion(.success(contests))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
