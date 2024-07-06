//
//  Configration.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation

struct ConfigurationManager {
    
    enum ConfigurationError: Error {
        case invalidPath
        case invalidInfo
    }
    
    enum Key: String {
        case apiKey = "APIKey"
        case imageURL = "imageURL"
        case accessToken = "accessToken"
    }
    
    static let shared = ConfigurationManager()
    
    private init() { }
    
    func xconfigValue(key: Key) throws -> String {
        guard let configURL = Bundle.main.url(forResource: "Config", withExtension: "xcconfig") else {
            throw ConfigurationError.invalidPath
        }
        print(configURL)
        let configString = try String(contentsOf: configURL)
        guard let apiKeyLine = configString.components(separatedBy: .newlines)
            .first(where: { $0.contains(key.rawValue) }) else {
            throw ConfigurationError.invalidInfo
        }
        
        let parts = apiKeyLine.components(separatedBy: "=")
        guard parts.count == 2 else {
            throw ConfigurationError.invalidInfo
        }
        
        let apiKey = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
        return apiKey
    }
}
