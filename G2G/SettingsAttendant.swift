//
//  SettingsAttendant.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import Foundation
import MapKit
import EventKit

let userDefaults = UserDefaults(suiteName: "group.com.paool.bathroom")

enum TransportMode: CaseIterable {
    case wheelchair
    case walking
    
    var name: String {
        switch self {
        case .wheelchair:
            return "Wheelchair"
        case .walking:
            return "Walking"
        }
    }
}

class SettingsAttendant: ObservableObject {
    static let shared = SettingsAttendant()
    
    static let transportModeKey = "TransportModeSetting"
    static let usesElectricWheelchairKey = "UsesElectricWheelchairSetting"
    static let walkingKey = "WalkingSpeedSetting"
    static let electricWheelchairKey = "ElectricWheelchairSpeedSetting"
    static let wheelchairKey = "WheelchairSpeedSetting"
    static let transitKey = "UsePublicTransitSetting"
    static let headingKey = "HeadingFilterSetting"
    static let gradientHourKey = "GradientHourSetting"
    static let gradientKey = "UseGradientSetting"
    static let calendarKey = "UseCalendarEventsSetting"

    static let defaultWheelchairSpeed = 4.0
    static let defaultElectricWheelchairSpeed = 5.0
    static let defaultWalkingSpeed = 3.0
    
    let eventStore = EKEventStore()
    
    @Published var transportMode: TransportMode {
        didSet {
            userDefaults?.set(transportMode.hashValue, forKey: SettingsAttendant.transportModeKey)
        }
    }
    
    @Published var useElectricWheelchair: Bool = false {
        didSet {
            userDefaults?.set(useElectricWheelchair, forKey: SettingsAttendant.usesElectricWheelchairKey)
        }
    }
    
    @Published var electricWheelchairSpeed: Double  {
        didSet {
            userDefaults?.set(electricWheelchairSpeed, forKey: SettingsAttendant.electricWheelchairKey)
        }
    }
    
    @Published var walkingSpeed: Double {
        didSet {
            userDefaults?.set(walkingSpeed, forKey: SettingsAttendant.walkingKey)
        }
    }
    
    @Published var wheelchairSpeed: Double  {
        didSet {
            userDefaults?.set(wheelchairSpeed, forKey: SettingsAttendant.wheelchairKey)
        }
    }

    @Published var headingFilter: Double?  {
        didSet {
            userDefaults?.set(headingFilter, forKey: SettingsAttendant.headingKey)
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
    
    @Published var useTimeGradients: Bool {
        didSet {
            userDefaults?.set(useTimeGradients, forKey: SettingsAttendant.gradientKey)
        }
    }
    
    @Published var gradientHour: Double  {
        didSet {
            userDefaults?.set(gradientHour, forKey: SettingsAttendant.gradientHourKey)
        }
    }
    
    @Published var useCalendarEvents: Bool = false {
        didSet {
            userDefaults?.set(useCalendarEvents, forKey: SettingsAttendant.calendarKey)
        }
    }
    
    init() {
        let storedMode = userDefaults?.object(forKey: SettingsAttendant.transportModeKey) as? TransportMode
        transportMode = storedMode ?? .walking
        let storedUseElectricWheelchair = userDefaults?.object(forKey: SettingsAttendant.usesElectricWheelchairKey) as? Bool
        useElectricWheelchair = storedUseElectricWheelchair ?? false
        let storedWalkingSpeed = userDefaults?.object(forKey: SettingsAttendant.walkingKey) as? Double
        walkingSpeed = storedWalkingSpeed ?? SettingsAttendant.defaultWalkingSpeed
        let storedWheelchairSpeed = userDefaults?.object(forKey: SettingsAttendant.wheelchairKey) as? Double
        wheelchairSpeed = storedWheelchairSpeed ?? SettingsAttendant.defaultWheelchairSpeed
        let storedElectricWheelchairSpeed = userDefaults?.object(forKey: SettingsAttendant.electricWheelchairKey) as? Double
        electricWheelchairSpeed = storedElectricWheelchairSpeed ?? SettingsAttendant.defaultElectricWheelchairSpeed
        
        let storedHeadingFilter = userDefaults?.object(forKey: SettingsAttendant.headingKey) as? Double
        headingFilter = storedHeadingFilter
        
        let storedGradientHour = userDefaults?.object(forKey: SettingsAttendant.gradientHourKey) as? Double
        gradientHour = storedGradientHour ?? 0
        
        let storedUseGradient = userDefaults?.object(forKey: SettingsAttendant.gradientKey) as? Bool
        useTimeGradients = storedUseGradient ?? true
        
        let storedUseCalendarEvents = userDefaults?.object(forKey: SettingsAttendant.calendarKey) as? Bool
        useCalendarEvents = storedUseCalendarEvents ?? false
    }
}
