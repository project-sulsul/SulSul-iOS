//
//  NetworkWrapper.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import Foundation
import Alamofire

public struct NetworkWrapper {
    public static let shared = NetworkWrapper()
    var apiDomain =  "http://sulsul-env.eba-gvmvk4bq.ap-northeast-2.elasticbeanstalk.com"
    private let jsonDecoder = JSONDecoder()
    
    public func getBasicTask(stringURL: String, parameters: Parameters? = nil, header: HTTPHeaders? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        var defaultHeader = configureHeader()
        header?.forEach { defaultHeader[$0.name] = $0.value }
        
        AF.request("\(apiDomain)\(stringURL)", method: .get, encoding: JSONEncoding.default, headers: defaultHeader).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    completion(.success(responseData))
                } else {
//                    completion(.failure(HTTPError.networkFailureError))
                }
            case .failure(let error):
                if let responseData = response.data, let json = try? jsonDecoder.decode(NetworkError.self, from: responseData) {
                    completion(.failure(NetworkError(statusCode: response.response?.statusCode, error: json.message, message: json.message)))
                } else {
                    completion(.failure(NetworkError(statusCode: response.response?.statusCode, message: error.localizedDescription)))
                }
            }
        }
    }
    
    public func deleteBasicTask(stringURL: String, parameters: Parameters? = nil, header: HTTPHeaders? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        var defaultHeader = configureHeader()
        header?.forEach { defaultHeader[$0.name] = $0.value }
        
        AF.request("\(apiDomain)\(stringURL)", method: .delete, encoding: JSONEncoding.default, headers: defaultHeader).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    completion(.success(responseData))
                } else {
//                    completion(.failure(HTTPError.networkFailureError))
                }
            case .failure(let error):
                if let responseData = response.data, let json = try? jsonDecoder.decode(NetworkError.self, from: responseData) {
                    completion(.failure(NetworkError(statusCode: response.response?.statusCode, error: json.message, message: json.message)))
                } else {
                    completion(.failure(NetworkError(statusCode: response.response?.statusCode, message: error.localizedDescription)))
                }
            }
        }
    }
    
    public func postBasicTask(stringURL: String, parameters: Parameters? = nil, header: HTTPHeaders? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        var defaultHeader = configureHeader()
        header?.forEach { defaultHeader[$0.name] = $0.value }
        AF.request("\(apiDomain)\(stringURL)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: defaultHeader).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    completion(.success(responseData))
                } else if response.data == nil {
                    completion(.success(Data()))
                } else {
//                    completion(.failure(HTTPError.networkFailureError))
                }
            case .failure(let error):
                if let responseData = response.data, let json = try? jsonDecoder.decode(NetworkError.self, from: responseData) {
                    completion(.failure(NetworkError(statusCode: error.responseCode, error: json.message, message: json.message)))
                } else {
                    completion(.failure(NetworkError(statusCode: error.responseCode, message: error.localizedDescription)))
                }
            }
        }
    }
    
    func putAuthMultiPartTask(images: [String: Data],
                              stringURL: String,
                              param: Parameters? = nil,
                              completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let imageName = images.first?.key,
              let imageData = images.first?.value,
              let url = URL(string: stringURL) else { return }
        
        let imageType = imageName.components(separatedBy: ".").last
        
        let headers = configureMultipartHeader(imageType: imageType ?? "jpg")
        
        AF.upload(imageData, to: url, method: .put, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if (200..<300).contains(statusCode) {
                    completion(.success(Data()))
                } else if let error = response.error {
                    if let responseData = response.data, let json = try? jsonDecoder.decode(NetworkError.self, from: responseData) {
                        completion(.failure(NetworkError(statusCode: response.response?.statusCode, error: json.message, message: json.message)))
                    } else {
                        completion(.failure(NetworkError(statusCode: response.response?.statusCode, message: error.localizedDescription)))
                    }
                }
            }
        }
    }
    
    func configureHeader() -> HTTPHeaders {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.session.configuration.timeoutIntervalForResource = 10
        
        let headers: HTTPHeaders = [ "Accept": "application/json" ]
        
        return headers
    }
    
    func configureMultipartHeader(imageType: String) -> HTTPHeaders {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.session.configuration.timeoutIntervalForResource = 10
        
        var headers: HTTPHeaders = [ "Accept": "application/json" ]
        headers["content-type"] = "image/\(imageType)"
        return headers
    }

}
