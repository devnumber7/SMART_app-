//
//  HomeStore.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import SwiftUI
import HomeKit

// View model that manages HomeKit homes.
class HomeKitViewModel: NSObject, ObservableObject, HMHomeManagerDelegate {
    @Published var homes: [HMHome] = []
    
    private let homeManager = HMHomeManager()
    
    override init() {
        super.init()
        homeManager.delegate = self
        // Initialize with the current list of homes.
        self.homes = homeManager.homes
    }
    
    // Called when HomeKit updates its homes.
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        DispatchQueue.main.async {
            self.homes = manager.homes
        }
    }

    func addHome(name: String){
        homeManager.addHome(withName: name){ home, error in
            if let error = error{
                print ("Error Adding Home: \(error.localizedDescription)")
            }
            else if let home = home{
                print("Added Home!")
            }
            
        }
    }
    
    func removeHome(name: String){
    if let homeToRemove = homeManager.homes.first(where: { $0.name == name }) {
        homeManager.removeHome(homeToRemove) { error in
            if let error = error {
                print("Error removing home: \(error.localizedDescription)")
            }else {
                print("Home removed!")
                }
            }
        }else {
        print("No home found with the name \(name)")
        }
    }
}
