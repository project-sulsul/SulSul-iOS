//
//  NetworkWrapper.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import UIKit
import Alamofire

struct ServerError: Decodable, Error {
    let detail: [Detail]
}

struct Detail: Decodable {
    let loc: [String]
    let msg: String
    let type: String
}

public struct NetworkWrapper {
    public static let shared = NetworkWrapper()
    var apiDomain =  "https://sulsul.link"
    private let jsonDecoder = JSONDecoder()
    
    public func postUploadImage(stringURL: String, image: UIImage, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageData = image.pngData() else {
            completion(.failure(NetworkError(message: "이미지 데이터 변환에 실패했습니다.")))
            return
        }
        
        var defaultHeader = tokenHeader()
        defaultHeader["Content-Type"] = "multipart/form-data"

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "image.png")
            
        }, to: "\(apiDomain)\(stringURL)", method: .post, headers: defaultHeader)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    completion(.success(responseData))
                } else {
                    completion(.failure(NetworkError(message: "empty data")))
                }
            case .failure(let error):
                if let responseData = response.data, let json = try? jsonDecoder.decode(ServerError.self, from: responseData) {
                     completion(.failure(json))
                } else {
                    completion(.failure(NetworkError(statusCode: response.response?.statusCode, message: error.localizedDescription)))
                }
            }
        }
    }
    
    public func putUploadImage(stringURL: String, imageUrl: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // 이미지 URL을 이용하여 서버에 요청을 보냅니다.
        guard let url = URL(string: "\(apiDomain)\(stringURL)?image_url=\(imageUrl)") else {
            completion(.failure(NetworkError(message: "URL 형식이 올바르지 않습니다.")))
            return
        }

        var defaultHeader = configureHeader()
        // 이미지 URL을 쿼리 파라미터로 보내므로 Content-Type은 application/json 또는 다른 적절한 형식으로 변경합니다.
        defaultHeader["Content-Type"] = "application/json"

        // Alamofire를 사용하여 PUT 요청을 보냅니다.
        AF.request(url, method: .put, headers: defaultHeader)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let responseData = response.data {
                        completion(.success(responseData))
                    } else {
                        completion(.failure(NetworkError(message: "empty data")))
                    }
                case .failure(let error):
                    if let responseData = response.data, let json = try? jsonDecoder.decode(ServerError.self, from: responseData) {
                        completion(.failure(json))
                    } else {
                        completion(.failure(NetworkError(statusCode: response.response?.statusCode, message: error.localizedDescription)))
                    }
                }
            }
    }
    
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
    
    public func deleteBasicTask(stringURL: String, parameters: Parameters? = nil, header: HTTPHeaders? = nil, needToken: Bool = false, completion: @escaping (Result<Data, Error>) -> Void) {
        var defaultHeader = configureHeader()
        
        if needToken {
            defaultHeader = tokenHeader()
        }
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
    
    public func postBasicTask(stringURL: String, parameters: Parameters? = nil, header: HTTPHeaders? = nil, needToken: Bool = false, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var defaultHeader = configureHeader()
        
        if needToken {
            defaultHeader = tokenHeader()
        }
        
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
    
    public func putBasicTask(stringURL: String, parameters: Parameters? = nil, header: HTTPHeaders? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        var defaultHeader = configureHeader()
        header?.forEach { defaultHeader[$0.name] = $0.value }
        
        AF.request("\(apiDomain)\(stringURL)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: defaultHeader).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    print(responseData)
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
    
    func tokenHeader() -> HTTPHeaders {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.session.configuration.timeoutIntervalForResource = 10
        
        var headers: HTTPHeaders = [ "Accept": "application/json" ]
        if let accessToken = KeychainStore.shared.read(label: "accessToken") {
            print("[AccessToken] \(accessToken)")
            headers.add(HTTPHeader(name: "authorization", value: "Bearer \(accessToken)"))
        }
        
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
