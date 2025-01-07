import SwiftUI

@main
struct iOSAuthAppApp: App {
    @ObservedObject var session = SessionStore.shared
    @StateObject var authViewModel = AuthViewModel()
    @State private var roomCount: Int = 1;
    
    var body: some Scene {
        WindowGroup {
            if session.token != nil {
                HomeView(roomCount: $roomCount)
                    .environmentObject(session)
            } else {
                LoginView(viewModel: authViewModel, roomCount: $roomCount )
            }
        }
    }
}

