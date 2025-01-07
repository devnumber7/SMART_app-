import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    var session: SessionStore;
    
    init(session: SessionStore = SessionStore.shared) {
            self.session = session
    }
    
    // Replace with your backend URL
    private let baseURL = "http://localhost:8000/api/auth"
    
    func register() {
        guard let url = URL(string: "\(baseURL)/register") else { return }
        
        let parameters = ["username": username, "email": email, "password": password]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 201 else {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: output.data)
                    throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: errorResponse?.message ?? "Registration failed"])
                }
                return output.data
            }
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Registration successful")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.user = response.user
                self.isAuthenticated = true
                SessionStore.shared.token = response.token
                SessionStore.shared.user = response.user
            }
            .store(in: &cancellables)
    }
    
    func login() {
        guard let url = URL(string: "\(baseURL)/login") else { return }
        
        let parameters = ["email": email, "password": password]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: output.data)
                    throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: errorResponse?.message ?? "Login failed"])
                }
                return output.data
            }
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Login successful")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.user = response.user
                self.isAuthenticated = true
                SessionStore.shared.token = response.token
                SessionStore.shared.user = response.user
            }
            .store(in: &cancellables)
    }
    
    func mockLogin() {
        if (email.isEmpty || password.isEmpty) {
            self.errorMessage = "Please enter both email and password.";
        }
        else {
            self.session.token = "mockToken123"
            self.session.user = User(username: "TestUser", email: "testuser@example.com")
            self.errorMessage = ""  // Clear any error message
            self.password = "1234"
            self.isAuthenticated = true
        }
    }
}

// For handling error responses
struct ErrorResponse: Codable {
    let message: String
}
