//
//  RequestManager.swift
//  TestTask
//
//  Created by Vladislav on 1.09.23.
//

import Foundation

typealias QueryStringParameters = [String: String]

struct RequestParams {
    let baseURL: String
    let method: Method = .GET
    var queryStringData: QueryStringParameters? = nil
    let api_key = "live_9U2GmakPWHQ276ZKub6ZTLrLcOKrD1P4n6cqkqBKqAynmQTJyscC6XgDMSNsRybR"
    var endpoint: String
    var subPath: String = ""
}

protocol RequestManagerProtocol {
    func makeRequest<T: Decodable>(reqestParameters: RequestParams, type: T.Type,
                     completion: @escaping (Result<T, Error>) -> Void)
    
}

final class RequestManager: RequestManagerProtocol {
    
    func makeRequest<T: Decodable>(reqestParameters: RequestParams, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = createURLRequest(parameters: reqestParameters)
        else {
            completion(.failure(NetworkErrors.unknownError))
            return
        }
        URLSession.shared.dataTask(with: request) { data,response,error in
            var result: Result<Data,Error>?
            if let error = error {
                result = .failure(error)
            } else
            if let data = data {
                result = .success(data)
            }
            DispatchQueue.main.async {
                self.handleResponse(result: result, type: type,  completion: completion)
            }
        }.resume()
    }
}

private extension RequestManager {
    
    func createURLRequest(parameters: RequestParams) -> URLRequest? {

        let urlString = parameters.baseURL

        guard let url = URL(string: urlString) else {return nil}

        var urlPath = url.appendingPathComponent(parameters.endpoint)
        urlPath = urlPath.appendingPathComponent(parameters.subPath)

        var urlRequest = URLRequest(url: urlPath)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        urlRequest.addValue( "application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("live_9U2GmakPWHQ276ZKub6ZTLrLcOKrD1P4n6cqkqBKqAynmQTJyscC6XgDMSNsRybR", forHTTPHeaderField: "x-api-key")
        urlRequest.httpMethod = parameters.method.rawValue

        
        if let params = parameters.queryStringData{
            switch parameters.method {
            case .GET:
                var urlComponent = URLComponents(url: urlPath, resolvingAgainstBaseURL: true)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            }
        }
        return urlRequest
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?,type: T.Type, completion: (Result<T, Error>) -> Void) {
        
        guard let result = result else {
            completion(.failure(NetworkErrors.unknownError))
            return
        }
        
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode (type, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

