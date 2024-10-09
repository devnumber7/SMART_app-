import SwiftUI

@main
struct iOSAuthAppApp: App {
    @ObservedObject var session = SessionStore.shared
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if session.token != nil {
                HomeView()
                    .environmentObject(session)
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
    }
}

