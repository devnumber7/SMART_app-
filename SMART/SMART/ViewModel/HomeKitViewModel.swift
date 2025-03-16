//
//  HomeStore.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import Foundation
import HomeKit
import SwiftUI

class HomeStore: NSObject, ObservableObject, HMHomeManagerDelegate {
    @Published var accessoriesInCurrentHome: [HMAccessory] = []
    @Published var homes: [HMHome] = []
    @Published var accessories: [HMAccessory] = []
    @Published var services: [HMService] = []
    @Published var characteristics: [HMCharacteristic] = []
    @Published var authorizationStatus: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true
    
    private var manager: HMHomeManager?
    
    override init() {
        super.init()
        print("DEBUG: HomeStore initializing")
        initializeHomeKit()
    }
    
    private func initializeHomeKit() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("DEBUG: Creating HMHomeManager")
            self.manager = HMHomeManager()
            self.manager?.delegate = self
        }
    }
    
    // MARK: - HMHomeManagerDelegate Methods
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("DEBUG: Updated Homes! Count: \(manager.homes.count)")
            self.homes = manager.homes
            self.isLoading = false
            
            if !self.authorizationStatus {
                self.authorizationStatus = true
                self.errorMessage = nil
            }
        }
    }
    
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("DEBUG: HomeKit authorization status updated: \(status)")
            
            switch status {
            case .authorized:
                self.authorizationStatus = true
                self.errorMessage = nil
            case .restricted:
                self.authorizationStatus = false
                self.errorMessage = "HomeKit access is restricted on this device"
            case .determined:
                self.authorizationStatus = false
                self.errorMessage = "HomeKit access needs to be granted"
            default:
                self.authorizationStatus = false
                self.errorMessage = "Please enable HomeKit access in Settings"
            }
            self.isLoading = false
        }
    }
    
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !self.homes.contains(where: { $0.uniqueIdentifier == home.uniqueIdentifier }) {
                self.homes.append(home)
                print("DEBUG: Home added: \(home.name)")
            }
        }
    }
    
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.homes.removeAll(where: { $0.uniqueIdentifier == home.uniqueIdentifier })
            print("DEBUG: Home removed: \(home.name)")
        }
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func fetchHomes() async {
        isLoading = true
        homes = manager?.homes ?? []
        isLoading = false
    }
    
    func addHome(name: String) {
        guard let manager = manager else {
            print("ERROR: HMHomeManager not initialized")
            return
        }
        
        manager.addHome(withName: name) { [weak self] home, error in
            if let error = error {
                print("ERROR: Failed to add home: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to add home: \(error.localizedDescription)"
                }
                return
            }
            
            if home != nil {
                DispatchQueue.main.async {
                    print("DEBUG: Successfully added home: \(name)")
                }
            }
        }
    }
    
    func deleteHome(home: HMHome) {
        guard let manager = manager else {
            print("ERROR: HMHomeManager not initialized")
            return
        }
        
        manager.removeHome(home) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to delete home: \(error.localizedDescription)"
                } else {
                    self?.homes.removeAll(where: { $0.uniqueIdentifier == home.uniqueIdentifier })
                }
            }
        }
    }
    
    // MARK: - Accessory Methods
    
    func findAccessories(homeId: UUID) {
        guard let devices = homes.first(where: { $0.uniqueIdentifier == homeId })?.accessories else {
            print("ERROR: No accessories found for home")
            return
        }
        accessories = devices
    }
    
    func loadAccessories(for home: HMHome) {
         accessoriesInCurrentHome = home.accessories
    }
    
    func findServices(accessoryId: UUID, homeId: UUID) {
        guard let accessoryServices = homes.first(where: { $0.uniqueIdentifier == homeId })?
            .accessories.first(where: { $0.uniqueIdentifier == accessoryId })?
            .services else {
            print("ERROR: No services found")
            return
        }
        services = accessoryServices
    }
    
    func findCharacteristics(serviceId: UUID, accessoryId: UUID, homeId: UUID) {
        guard let serviceCharacteristics = homes.first(where: { $0.uniqueIdentifier == homeId })?
            .accessories.first(where: { $0.uniqueIdentifier == accessoryId })?
            .services.first(where: { $0.uniqueIdentifier == serviceId })?
            .characteristics else {
            print("ERROR: No characteristics found")
            return
        }
        characteristics = serviceCharacteristics
    }
    
    func toggleAccessoryState(for accessory: HMAccessory, completion: ((Bool) -> Void)? = nil) {
        guard let powerService = accessory.services.first(where: {
            $0.serviceType == HMServiceTypeLightbulb ||
            $0.serviceType == HMServiceTypeOutlet ||
            $0.serviceType == HMServiceTypeSwitch
        }) else {
            print("No suitable power service found for \(accessory.name)")
            completion?(false)
            return
        }
        
        guard let powerCharacteristic = powerService.characteristics.first(where: {
            $0.characteristicType == HMCharacteristicTypePowerState
        }) else {
            print("No power characteristic available for \(accessory.name)")
            completion?(false)
            return
        }
        
        let currentValue = powerCharacteristic.value as? Bool ?? false
        let newValue = !currentValue
        
        powerCharacteristic.writeValue(newValue) { error in
            if let error = error {
                print("Error toggling state for \(accessory.name): \(error.localizedDescription)")
                completion?(false)
            } else {
                print("\(accessory.name) toggled successfully to \(newValue ? "ON" : "OFF")")
                completion?(true)
            }
        }
    }
    
    func removeAccessory(home: HMHome, accessory: HMAccessory) {
        home.removeAccessory(accessory) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to remove accessory: \(error.localizedDescription)"
                } else {
                    print("Accessory removed successfully from \(home.name)")
                    if let index = self?.accessories.firstIndex(where: {
                        $0.uniqueIdentifier == accessory.uniqueIdentifier
                    }) {
                        self?.accessories.remove(at: index)
                    }
                }
            }
        }
    }
}
