import Foundation
import SwiftUI

class SessionStore: ObservableObject {
    static let shared = SessionStore()
    
    @Published var token: String? {
        didSet {
            if let token = token {
                KeychainHelper.standard.save(token, service: "auth", account: "token")
            } else {
                KeychainHelper.standard.delete(service: "auth", account: "token")
            }
        }
    }
    
    @Published var user: User?
    
     init() {
        self.token = KeychainHelper.standard.read(service: "auth", account: "token")
        // Optionally, fetch user details from the token or backend
    }
}


class MockSessionStore : SessionStore {
    override init() {
        super.init();
        self.token = "mockToken123";
        self.user = User(username: "TestUser", email: "testuser@example.com");
        
    }
}
