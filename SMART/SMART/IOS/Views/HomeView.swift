import SwiftUI

struct HomeView: View {
    @ObservedObject var session = SessionStore.shared
    
    var body: some View {
        VStack(spacing: 20) {
            if let user = session.user {
                Text("Welcome, \(user.username)!")
                    .font(.title)
            }
            
            Button(action: {
                session.token = nil
                session.user = nil
            }) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(5)
            }
        }
        .padding()
    }
}

