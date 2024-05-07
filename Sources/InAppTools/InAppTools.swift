import Foundation

public class MailingList {
    private let apiKey: String
    private let session: URLSession
    private let baseURL: URL
    
    public struct Member: Codable, Equatable {
        public let uuid: String
        public let email: String
        public let firstName: String?
        public let lastName: String?
        public let name: String?
        public let fields: [String: String]?
        public let tags: [String]?
        public let status: Status
    }
    
    public enum Status: String, Codable {
        case subscribed
        case unsubscribed
        case pending
    }

    private struct MemberChanges: Codable {
        let email: String?
        let firstName: String?
        let lastName: String?
        let name: String?
        let fields: [String: String]?
        let tags: [String]?
        let status: Status
    }

    private struct StatusChanges: Codable {
        let status: Status
    }

    public init(apiKey: String, session: URLSession = .shared, baseURL: URL = URL(string: "https://api.inapptools.com/v1/")!) {
        self.apiKey = apiKey
        self.session = session
        self.baseURL = baseURL
    }
    
    public func subscribe(listId: String, email: String, firstName: String? = nil, lastName: String? = nil, name: String? = nil, fields: [String: String]? = nil, tags: [String]? = nil) async throws -> Member {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try jsonEncoder.encode(MemberChanges(email: email, firstName: firstName, lastName: lastName, name: name, fields: fields, tags: tags, status: .subscribed))
        let url = baseURL.appendingPathComponent("lists/\(listId)/members/\(email)/")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        let (data, response) = try await session.data(for: request)
        try validateHttpResponse(data: data, response: response)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(Member.self, from: data)
    }
    
    public func unsubscribe(listId: String, uuid: String) async throws -> Member {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try jsonEncoder.encode(StatusChanges(status: .unsubscribed))
        let url = baseURL.appendingPathComponent("lists/\(listId)/members/\(uuid)/")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        let (data, response) = try await session.data(for: request)
        try validateHttpResponse(data: data, response: response)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(Member.self, from: data)
    }
    
    // MARK: Implementation helpers
    
    private func validateHttpResponse(data: Data, response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw InAppToolsError.invalidResponse
        }
        
        switch http.statusCode {
        case 200...299:
            return
            
        case 400...599:
            let body = String(data: data, encoding: .utf8) ?? ""
            throw InAppToolsError.requestError(http.statusCode, body)
            
        default:
            throw InAppToolsError.invalidResponse
        }
    }
}
