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
    
    private init() {
        self.token = KeychainHelper.standard.read(service: "auth", account: "token")
        // Optionally, fetch user details from the token or backend
    }
}
