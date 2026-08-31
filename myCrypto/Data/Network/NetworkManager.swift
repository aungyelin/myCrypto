//
//  NetworkManager.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation

enum AppEnvironment {
    case development
    case staging
    case production
}

struct AppConfiguration {
    static let shared = AppConfiguration()
    
    var environment: AppEnvironment = .production
    
    var apiBaseURL: String {
        switch environment {
        case .development, .staging, .production:
            return "https://api.coingecko.com/api/v3/coins"
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = AppConfiguration.shared.apiBaseURL
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        var urlComponents = URLComponents(string: baseURL + endpoint)
        if let queryItems = queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError(message: "Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        printResponse(url: url.absoluteString, method: method)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError(message: "Invalid Response")
        }
        
        printResponse(url: url.absoluteString, method: method, statusCode: httpResponse.statusCode, data: data)
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let decodedError = decodeNetworkError(from: data) {
                throw decodedError
            } else {
                throw NetworkError(message: "Server Error: \(httpResponse.statusCode)")
            }
        }
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw NetworkError(message: "Decoding Error: \(error.localizedDescription)")
        }
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
        
        struct GenericErrorMessage: Decodable { let message: String?; let error: String?; let error_message: String? }
        if let generic = try? decoder.decode(GenericErrorMessage.self, from: data) {
            if let msg = generic.message ?? generic.error ?? generic.error_message, !msg.isEmpty {
                return NetworkError(message: msg)
            }
        }
        
        return nil
    }
    
    private func printResponse(url: String, method: String, statusCode: Int? = nil, data: Data? = nil) {
        if statusCode == nil {
            print("\n===== 📡 Network Request =====")
            print("➡️ URL: \(method) \(url)")
        } else {
            print("\n===== 📡 Network Response =====")
            print("➡️ URL: \(method) \(url)")
            if let statusCode = statusCode { print("📦 Status: \(statusCode)") }
            if let data = data {
                if let bodyString = String(data: data, encoding: .utf8) {
                    print("📝 Body:\n\(bodyString)")
                } else {
                    print("📝 Body: <non-UTF8 data, \(data.count) bytes>")
                }
            }
            print("===== 📡 End Response =====\n")
        }
    }
}
