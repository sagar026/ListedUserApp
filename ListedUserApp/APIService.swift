//
//  APIService.swift
//  ListedUserApp
//
//  Created by Vidhyasagar on 05/05/25.
//

import Foundation

protocol CommonRequestRepresentable {
    associatedtype Response: Decodable
    var url: String { get }
    var method: String { get }
    var requestBody: Data? { get }
    var urlRequest: URLRequest? { get }
}

struct GetUsersRequest: CommonRequestRepresentable {
    typealias Response = UserListResponse
    
    var url: String {
        "https://jsonplaceholder.typicode.com/users"
    }
    
    var method: String {
        "GET"
    }
    
    var requestBody: Data? {
        .none
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = requestBody
        return request
    }
    
}

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case other(String)
}

final class APIService {
    typealias CommonRequest = CommonRequestRepresentable
    func request<CommonRequest>(request: CommonRequest) async throws -> CommonRequest.Response where CommonRequest: CommonRequestRepresentable {
        guard let request = request.urlRequest else {
            throw ServiceError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(CommonRequest.Response.self, from: data)
            return responseData
        } catch {
            throw ServiceError.other(error.localizedDescription)
        }
    }
}
