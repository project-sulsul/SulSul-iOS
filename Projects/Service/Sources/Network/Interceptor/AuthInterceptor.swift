//
//  AuthInterceptor.swift
//  Service
//
//  Created by 김유진 on 3/2/24.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var adaptedRequest = urlRequest
        if let accessToken = KeychainStore.shared.read(label: "accessToken") {
            adaptedRequest.headers.add(HTTPHeader(name: "Authorization", value: accessToken))
        }
        completion(.success(adaptedRequest))
    }
}
 
