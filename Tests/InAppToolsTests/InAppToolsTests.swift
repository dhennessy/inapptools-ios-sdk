import XCTest
import Mocker
@testable import InAppTools

final class InAppToolsTests: XCTestCase {
    let apiKey = "xyzzy"

    override func tearDownWithError() throws {
        Mocker.removeAll()
    }
    
    func testSubscribeBadApiKey() async throws {
        let url = URL(string: "https://api.inapptools.com/v1/lists/mylist/members/alice@example.com/")!
        let data = try! JSONSerialization.data(withJSONObject: ["detail": "Unauthorized"])
        let mock = Mock(url: url, statusCode: 401, data: [.put: data])
        mock.register()
        
        do {
            _ = try await MailingList(apiKey: "badKey").subscribe(listId: "mylist", email: "alice@example.com")
            XCTFail()
        } catch {
            if let e = error as? InAppToolsError, case let InAppToolsError.requestError(statusCode, body) = e {
                XCTAssertEqual(statusCode, 401)
                XCTAssertEqual(body, "{\"detail\":\"Unauthorized\"}")
            } else {
                XCTFail()
            }
        }
    }

    func testSubscribeBadListId() async throws {
        let url = URL(string: "https://api.inapptools.com/v1/lists/badlist/members/alice@example.com/")!
        let data = try! JSONSerialization.data(withJSONObject: ["detail": "Unauthorized"])
        let mock = Mock(url: url, statusCode: 404, data: [.put: data])
        mock.register()
        
        do {
            _ = try await MailingList(apiKey: apiKey).subscribe(listId: "badlist", email: "alice@example.com")
            XCTFail()
        } catch {
            if let e = error as? InAppToolsError, case let InAppToolsError.requestError(statusCode, _) = e {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail()
            }
        }
    }

    func testSubscribeSuccess() async throws {
        let url = URL(string: "https://api.inapptools.com/v1/lists/mylist/members/alice@example.com/")!
        let memberAlice = MailingList.Member(uuid: "012345", email: "alice@example.com", first_name: nil, last_name: nil, name: nil, fields: nil, tags: nil)
        let data = try JSONEncoder().encode(memberAlice)
        var mock = Mock(url: url, statusCode: 201, data: [.put: data])
        mock.onRequestHandler = OnRequestHandler(jsonDictionaryCallback: { request, body in
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertEqual(request.value(forHTTPHeaderField: "X-API-Key"), self.apiKey)
            XCTAssertEqual(body!["email"] as! String, "alice@example.com")
        })
        mock.register()
        
        let member = try await MailingList(apiKey: apiKey).subscribe(listId: "mylist", email: "alice@example.com")
        
        XCTAssertEqual(member, memberAlice)
    }
}
