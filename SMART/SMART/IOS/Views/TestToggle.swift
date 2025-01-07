
import SwiftUI

struct CustomToggleView: View {
    @State private var isActivated: Bool = false // Track the toggle state
    let deviceId: String // Device ID for the specific toggle
    
    var body: some View {
        VStack {
            Toggle("On/Off", isOn: $isActivated)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .onChange(of: isActivated) { newValue in
                    print("Device ID: \(deviceId), New State: \(newValue)") // Debugging information
                    controlESP32(state: newValue)
                }
                .padding()
                .foregroundColor(.white)
        }
    }
    
    /// Function to send HTTP POST request to ESP32
    private func controlESP32(state: Bool) {
        let url = URL(string: "https://192.168.4.1:5000/control-method")! // Proxy server URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Define the action based on toggle state
        let action = state ? "activate" : "deactivate"
        let body = "action=\(action)&device_id=\(deviceId)" // Attach device_id to the request
        request.httpBody = body.data(using: .utf8)
        
        // Debugging: Print the body of the request
        print("Sending request: \(body)")
        
        // Send the HTTP request
        let session = URLSession(configuration: .default, delegate: CustomURLSessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("No response from server.")
                return
            }
            if response.statusCode == 200 {
                print("Device \(self.deviceId) \(action) successfully!")
            } else {
                print("Failed to \(action) device \(self.deviceId). HTTP Status Code: \(response.statusCode)")
            }
        }
        task.resume()
    }
}
