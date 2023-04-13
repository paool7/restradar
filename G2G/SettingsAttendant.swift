//
//  SettingsAttendant.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import Foundation
import MapKit

class SettingsAttendant: ObservableObject {
    static let shared = SettingsAttendant()
    
    static let transportModeKey = "TransportModeSetting"
    static let usesElectricWheelchairKey = "UsesElectricWheelchairSetting"
    static let walkingKey = "WalkingSpeedSetting"
    static let electricWheelchairKey = "ElectricWheelchairSpeedSetting"
    static let wheelchairKey = "WheelchairSpeedSetting"
    static let transitKey = "UsePublicTransitSetting"
    static let headingKey = "HeadingFilterSetting"

    static let defaultWheelchairSpeed = 4.0
    static let defaultElectricWheelchairSpeed = 5.0
    static let defaultWalkingSpeed = 3.0
    
    @Published var transportMode: TransportMode {
        didSet {
            UserDefaults.standard.set(transportMode.hashValue, forKey: SettingsAttendant.transportModeKey)
        }
    }
    
    @Published var useElectricWheelchair: Bool = false {
        didSet {
            UserDefaults.standard.set(useElectricWheelchair, forKey: SettingsAttendant.usesElectricWheelchairKey)
        }
    }
    
    @Published var electricWheelchairSpeed: Double  {
        didSet {
            UserDefaults.standard.set(electricWheelchairSpeed, forKey: SettingsAttendant.electricWheelchairKey)
        }
    }
    
    @Published var walkingSpeed: Double {
        didSet {
            UserDefaults.standard.set(walkingSpeed, forKey: SettingsAttendant.walkingKey)
        }
    }
    
    @Published var wheelchairSpeed: Double  {
        didSet {
            UserDefaults.standard.set(wheelchairSpeed, forKey: SettingsAttendant.wheelchairKey)
        }
    }

    @Published var headingFilter: Double?  {
        didSet {
            UserDefaults.standard.set(headingFilter, forKey: SettingsAttendant.headingKey)
        }
    }
    @Published var headingStringValue: String = "" {
        didSet {
            if let doubleValue = Double(headingStringValue) {
                self.headingFilter = doubleValue
                LocationAttendant.shared.locationManager.headingFilter = doubleValue
            } else {
                self.headingFilter = nil
            }
        }
    }
    
    init() {
        let storedMode = UserDefaults.standard.object(forKey: SettingsAttendant.transportModeKey) as? TransportMode
        transportMode = storedMode ?? .walking
        let storedUseElectricWheelchair = UserDefaults.standard.object(forKey: SettingsAttendant.usesElectricWheelchairKey) as? Bool
        useElectricWheelchair = storedUseElectricWheelchair ?? false
        let storedWalkingSpeed = UserDefaults.standard.object(forKey: SettingsAttendant.walkingKey) as? Double
        walkingSpeed = storedWalkingSpeed ?? SettingsAttendant.defaultWalkingSpeed
        let storedWheelchairSpeed = UserDefaults.standard.object(forKey: SettingsAttendant.wheelchairKey) as? Double
        wheelchairSpeed = storedWheelchairSpeed ?? SettingsAttendant.defaultWheelchairSpeed
        let storedElectricWheelchairSpeed = UserDefaults.standard.object(forKey: SettingsAttendant.electricWheelchairKey) as? Double
        electricWheelchairSpeed = storedElectricWheelchairSpeed ?? SettingsAttendant.defaultElectricWheelchairSpeed
        
        let storedHeadingFilter = UserDefaults.standard.object(forKey: SettingsAttendant.headingKey) as? Double
        headingFilter = storedHeadingFilter
    }
}