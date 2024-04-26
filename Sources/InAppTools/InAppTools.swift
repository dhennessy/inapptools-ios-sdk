import Foundation

enum InAppToolsError: Error {
    case invalidResponse
    case requestError(Int, String)  // HTTP 4xx / 5xx
}

class MailingList {
    private let apiKey: String
    private let session: URLSession
    private let baseURL = URL(string: "https://api.inapptools.com/v1/")!
    
    struct Member: Codable, Equatable {
        let uuid: String
        let email: String
    }

    private struct MemberChanges: Codable {
        let email: String?
    }

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func subscribe(listId: String, email: String) async throws -> Member {
        let url = baseURL.appendingPathComponent("lists/\(listId)/members/\(email)/")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(MemberChanges(email: email))
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
