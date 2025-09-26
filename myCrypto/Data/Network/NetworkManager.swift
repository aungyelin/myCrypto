//
//  NetworkManager.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.coingecko.com/api/v3/coins"
    
    
    private func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        return Single.create { single in
            let request = AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
                .validate()
                .responseDecodable(of: T.self) { response in
                    self.printResponse(response)
                    switch response.result {
                    case .success(let value): single(.success(value))
                    case .failure(_):
                        if let data = response.data, let decodedError = self.decodeNetworkError(from: data) {
                            single(.failure(decodedError))
                        } else {
                            single(.failure(NetworkError(message: response.error?.localizedDescription ?? "Network Error")))
                        }
                    }
                }
            return Disposables.create { request.cancel() }
        }
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        let fullURL = baseURL + endpoint
        
        return self.request(
            url: fullURL,
            method: method,
            parameters: parameters,
            headers: headers
        )
    }

    private func decodeNetworkError(from data: Data) -> NetworkError? {
        let decoder = JSONDecoder()
        
        if let envelope = try? decoder.decode(APIErrorResponse.self, from: data) {
            if let message = envelope.status.error_message, !message.isEmpty {
                return NetworkError(message: message)
            }
            if let code = envelope.status.error_code {
                return NetworkError(message: "Error code \(code)")
            }
        }
        
        // Try some common fallback shapes if the API changes
        struct GenericErrorMessage: Decodable { let message: String?; let error: String?; let error_message: String? }
        if let generic = try? decoder.decode(GenericErrorMessage.self, from: data) {
            if let msg = generic.message ?? generic.error ?? generic.error_message, !msg.isEmpty {
                return NetworkError(message: msg)
            }
        }
        
        return nil
    }
    
    private func printResponse<T>(_ response: DataResponse<T, AFError>) {
        let url = response.request?.url?.absoluteString ?? "<unknown URL>"
        let method = response.request?.method?.rawValue ?? "<unknown method>"
        let statusCode = response.response?.statusCode
        print("\n===== 📡 Network Response =====")
        print("➡️ URL: \(method) \(url)")
        if let statusCode { print("📦 Status: \(statusCode)") }
        if let headers = response.response?.allHeaderFields as? [String: Any], !headers.isEmpty {
            print("🧾 Headers: \(headers)")
        }
        if let data = response.data {
            if let bodyString = String(data: data, encoding: .utf8) {
                print("📝 Body:\n\(bodyString)")
            } else {
                print("📝 Body: <non-UTF8 data, \(data.count) bytes>")
            }
        }
        if let error = response.error {
            print("❌ Error: \(error.localizedDescription)")
        }
        print("===== 📡 End Response =====\n")
    }
    
}
