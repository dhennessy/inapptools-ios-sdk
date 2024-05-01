import Foundation

enum InAppToolsError: Error {
    case invalidResponse
    case requestError(Int, String)  // HTTP 4xx / 5xx
}

public class MailingList {
    private let apiKey: String
    private let session: URLSession
    private let baseURL = URL(string: "https://api.inapptools.com/v1/")!
    
    public struct Member: Codable, Equatable {
        let uuid: String
        let email: String
        let first_name: String?
        let last_name: String?
        let name: String?
        let fields: [String: String]?
        let tags: [String]?
    }
    
    private struct MemberChanges: Codable {
        let email: String?
        let first_name: String?
        let last_name: String?
        let name: String?
        let fields: [String: String]?
        let tags: [String]?
    }
    
    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    public func subscribe(listId: String, email: String, first_name: String? = nil, last_name: String? = nil, name: String? = nil, fields: [String: String]? = nil, tags: [String]? = nil) async throws -> Member {
        let url = baseURL.appendingPathComponent("lists/\(listId)/members/\(email)/")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(MemberChanges(email: email, first_name: first_name, last_name: last_name, name: name, fields: fields, tags: tags))
        let (data, response) = try await session.data(for: request)
        try validateHttpResponse(data: data, response: response)
        return try JSONDecoder().decode(Member.self, from: data)
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
