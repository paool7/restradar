//
//  SettingsAttendant.swift
//  G2G
//
//  Created by Paul Dippold on 4/8/23.
//

import Foundation
import MapKit
import EventKit
import SwiftUI

let userDefaults = UserDefaults(suiteName: "group.com.paool.bathroom")

enum Handed: Int, CaseIterable {
    case right
    case left
    
    var name: String {
        switch self {
        case .right:
            return "Right"
        case .left:
            return "Left"
        }
    }
}

enum Theme: Int, CaseIterable {
    case sunsetsunrise = 0
    case random = 1
    
    var name: String {
        switch self {
        case .sunsetsunrise:
            return "Sunrise to Sunset"
        case .random:
            return "Assortment"
        }
    }
}

enum TransportMode: Int, CaseIterable {
    case walking
    case wheelchair
    
    var name: String {
        switch self {
        case .wheelchair:
            return "Wheelchair"
        case .walking:
            return "Walking"
        }
    }
    
    var image: Image {
        switch self {
        case .wheelchair:
            return Image(systemName: "figure.roll")
        case .walking:
            return Image(systemName: "figure.walk.motion")
        }
    }
    
    var verb: String {
        switch self {
        case .wheelchair:
            return "Wheel"
        case .walking:
            return "Walk"
        }
    }
    
}

enum DistanceMeasurement: Int, CaseIterable {
    case blocks
    case meterskilometers
    case milesfeet
    case steps

    var name: String {
        switch self {
        case .milesfeet:
            return "Feet/Miles"
        case .blocks:
            return "Blocks"
        case .steps:
            return "Steps"
        case .meterskilometers:
            return "Meters/Kilometers"
        }
    }
    
    var image: Image {
        switch self {
        case .milesfeet, .meterskilometers:
            return Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
        case .blocks:
            return Image(systemName: "building.2")
        case .steps:
            return Image(systemName: "shoeprints.fill")
        }
    }
}

enum MapProvider: Int, CaseIterable {
    case apple
    case google

    var name: String {
        switch self {
        case .apple:
            return "Apple"
        case .google:
            return "Google"
        }
    }
    
    var image: Image {
        switch self {
        case .apple:
            return Image(systemName: "apple.logo")
        case .google:
            return Image(systemName: "g.circle")
        }
    }
    
}

class SettingsAttendant: ObservableObject {
    static let shared = SettingsAttendant()
    
    static let distanceMeasurementKey = "DistanceMeasurementSetting"
    static let transportModeKey = "TransportModeSetting"
    static let usesElectricWheelchairKey = "UsesElectricWheelchairSetting"
    static let walkingKey = "WalkingSpeedSetting"
    static let electricWheelchairKey = "ElectricWheelchairSpeedSetting"
    static let wheelchairKey = "WheelchairSpeedSetting"
    static let transitKey = "UsePublicTransitSetting"
    static let headingKey = "HeadingFilterSetting"
    static let gradientHourKey = "GradientHourSetting"
    static let gradientKey = "UseGradientSetting"
    static let gradientThemeKey = "GradientThemeSetting"
    static let handKey = "PrimaryHandSettings"
    static let stepKey = "StepLengthSetting"
    static let mapKey = "MapProviderSetting"

    static let defaultWheelchairSpeed = 4.0
    static let defaultElectricWheelchairSpeed = 5.0
    static let defaultWalkingSpeed = 3.0
    static let defaultStepLength = 2.5

    let eventStore = EKEventStore()
    
    @Published var distanceMeasurement: DistanceMeasurement {
        didSet {
            userDefaults?.set(distanceMeasurement.rawValue, forKey: SettingsAttendant.distanceMeasurementKey)
        }
    }
    
    @Published var transportMode: TransportMode {
        didSet {
            userDefaults?.set(transportMode.rawValue, forKey: SettingsAttendant.transportModeKey)
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
    
    @Published var stepLength: Double  {
        didSet {
            userDefaults?.set(stepLength, forKey: SettingsAttendant.stepKey)
        }
    }
    
    @Published var headingFilter: Double = 0.0 {
        didSet {
            userDefaults?.set(headingFilter, forKey: SettingsAttendant.headingKey)
            LocationAttendant.shared.locationManager.headingFilter = headingFilter
        }
    }
    
    @Published var gradientTheme: Theme {
        didSet {
            userDefaults?.set(gradientTheme.rawValue, forKey: SettingsAttendant.gradientThemeKey)
        }
    }
    
    @Published var useTimeGradients: Bool {
        didSet {
            userDefaults?.set(useTimeGradients, forKey: SettingsAttendant.gradientKey)
        }
    }
    
    @Published var gradientHour: Double {
        didSet {
            userDefaults?.set(gradientHour, forKey: SettingsAttendant.gradientHourKey)
        }
    }
    
    @Published var primaryHand: Handed {
        didSet {
            userDefaults?.set(primaryHand.rawValue, forKey: SettingsAttendant.handKey)
        }
    }
    
    @Published var mapProvider: MapProvider {
        didSet {
            userDefaults?.set(mapProvider.rawValue, forKey: SettingsAttendant.mapKey)
        }
    }
    
    init() {
        let storedMode = userDefaults?.object(forKey: SettingsAttendant.transportModeKey) as? Int ?? 0
        transportMode = TransportMode(rawValue: storedMode) ?? .walking
        let storedUseElectricWheelchair = userDefaults?.object(forKey: SettingsAttendant.usesElectricWheelchairKey) as? Bool
        useElectricWheelchair = storedUseElectricWheelchair ?? false
        let storedWalkingSpeed = userDefaults?.object(forKey: SettingsAttendant.walkingKey) as? Double
        walkingSpeed = storedWalkingSpeed ?? SettingsAttendant.defaultWalkingSpeed
        let storedWheelchairSpeed = userDefaults?.object(forKey: SettingsAttendant.wheelchairKey) as? Double
        wheelchairSpeed = storedWheelchairSpeed ?? SettingsAttendant.defaultWheelchairSpeed
        let storedElectricWheelchairSpeed = userDefaults?.object(forKey: SettingsAttendant.electricWheelchairKey) as? Double
        electricWheelchairSpeed = storedElectricWheelchairSpeed ?? SettingsAttendant.defaultElectricWheelchairSpeed
        
        let storedHeadingFilter = userDefaults?.object(forKey: SettingsAttendant.headingKey) as? Double ?? 0.0
        headingFilter = storedHeadingFilter
        
        let storedGradientHour = userDefaults?.object(forKey: SettingsAttendant.gradientHourKey) as? Double
        gradientHour = storedGradientHour ?? LocationAttendant.shared.currentHourValue
        
        let storedUseGradient = userDefaults?.object(forKey: SettingsAttendant.gradientKey) as? Bool
        useTimeGradients = storedUseGradient ?? true
        
        let storedGradientTheme = userDefaults?.object(forKey: SettingsAttendant.gradientThemeKey) as? Int
        gradientTheme = Theme(rawValue: storedGradientTheme ?? 0) ?? Theme.sunsetsunrise
        
        let storedPrimaryHand = userDefaults?.object(forKey: SettingsAttendant.handKey) as? Int
        primaryHand = Handed(rawValue: storedPrimaryHand ?? 0) ?? Handed.right
        
        let storedStepLength = userDefaults?.object(forKey: SettingsAttendant.stepKey) as? Double
        stepLength = storedStepLength ?? SettingsAttendant.defaultStepLength
        
        let storedDistanceMeasurement = userDefaults?.object(forKey: SettingsAttendant.distanceMeasurementKey) as? Int ?? 0
        distanceMeasurement = DistanceMeasurement(rawValue: storedDistanceMeasurement) ?? .blocks
        
        let storedMapProvider = userDefaults?.object(forKey: SettingsAttendant.mapKey) as? Int ?? 0
        mapProvider = MapProvider(rawValue: storedMapProvider) ?? .apple
    }
}
