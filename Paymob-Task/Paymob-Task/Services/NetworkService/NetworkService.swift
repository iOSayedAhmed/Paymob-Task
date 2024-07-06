//
//  NetworkService.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import Network


class NetworkService {
    enum Endpoint: String {
        case nowPlaying = "now_playing"
        case popular = "popular"
        case upcomming = "upcoming"
    }

    private let session: URLSession
    private let config = ConfigurationManager.shared

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func isNetworkConnected() -> Bool {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false

        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }

        let queue = DispatchQueue.global(qos: .userInitiated)
        monitor.start(queue: queue)

        _ = semaphore.wait(timeout: .now() + 5)

            return isConnected
    }

    public func request<T: Codable>(path: Endpoint, parameters: [String: String]) async throws -> T {
        guard isNetworkConnected() else { throw NetworkError.notConnected }

        do {
            let fullURL = try? addParametersToURL(baseURL: Constants.baseURL, path: path, parameters: parameters)
            var request = URLRequest(url: fullURL!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            if let accessToken = try? config.xconfigValue(key: .accessToken) {
                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
            
            print("GET", request.url?.absoluteString ?? "")
            
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            let _data = try handleErrors(statusCode: httpResponse.statusCode, data: data)

            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: _data)

            //encode data to display it as pretty json
            let prettyPrintedData = try JSONEncoder().encode(decodedData)
            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                print(prettyPrintedString)
            }
            return decodedData

        } catch {
            throw NetworkError.unknownError(statusCode: nil)
        }
    }

    func addParametersToURL(baseURL: String, path: Endpoint, parameters: [String: String]) throws -> URL? {
        var urlComponents = URLComponents(string: baseURL + path.rawValue)
        guard let _ = urlComponents else {
            throw NetworkError.invalidURL
        }

        var queryItems: [URLQueryItem] = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        queryItems.append(URLQueryItem(name: "language", value: "en-US"))
        queryItems.append(URLQueryItem(name: "limit", value: "10"))
        
        if let apiKey = try? config.xconfigValue(key: .apiKey) {
            queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        }
        
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else { return nil }

        return url
    }

    private func handleErrors(statusCode: Int, data: Data) throws -> Data {
        switch statusCode {
        case 200..<300:
            return data
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknownError(statusCode: statusCode)
        }
    }
}
