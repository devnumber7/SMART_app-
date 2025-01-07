//
//  CustomToggle.swift
//  SMART
//
//  Created by Anson Jiang on 12/7/24.
//
import SwiftUI
import Foundation

struct CustomToggle: ToggleStyle {
    
    
    
    
    
    func makeBody(configuration: Configuration) -> some View {
            Toggle(configuration)
                .padding()
    }
    
    
    
   static func toggle(ip: String) {
        
        guard let ethansURL =  URL(string:"http://" + ip) else { return }
        
        
        //let body = ""
        
        //let finalBody = body.data(using: .utf8)
        
        var request = URLRequest(url: ethansURL)
        
        request.httpMethod = "POST /control-method"
        
        //request.httpBody = finalBody
        
        
        
        URLSession.shared.dataTask(with: request){
            
            (data, response, error) in
        }
    }
}







