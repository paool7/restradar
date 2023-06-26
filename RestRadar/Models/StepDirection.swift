//
//  StepDirection.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/26/23.
//

import Foundation

enum DirectionRange {
    static let lowerNorthRange = 0.0...44.9999
    static let upperNorthRange = 315.0...359.999
    static let eastRange = 45.0...134.9999
    static let southRange = 135.0...224.999
    static let westRange = 225.0...315.999
    case outOfRange
    
    static func stepDirection(_ value: Double) -> StepDirection {
        switch value {
        case DirectionRange.lowerNorthRange, DirectionRange.upperNorthRange:
            return .north
        case DirectionRange.eastRange:
            return .east
        case DirectionRange.southRange:
            return .south
        case DirectionRange.westRange:
            return .west
        default:
            return .north
        }
    }
}

enum TurnDirection: Identifiable {
    case left
    case right
    case uturn
    case none
    
    var id: Self {
        return self
    }
    
    var imageName: String {
        switch self {
        case .left:
            return "arrow.turn.up.left"
        case .right:
            return "arrow.turn.up.right"
        case .uturn:
            return "arrow.uturn.down"
        default:
            return "figure.walk.motion"
        }
    }
}

enum StepDirection {
    case north
    case east
    case south
    case west
    
    var blockWidth: Double {
        switch self {
        case .north, .south:
            return 375.0
        case .east, .west:
            return 750.0
        }
    }
    
    func turnFrom(previousDirection: StepDirection?) -> TurnDirection? {
        guard let previousDirection = previousDirection else { return nil }
        switch previousDirection {
        case .north:
            switch self {
            case .north:
                return TurnDirection.none
            case .east:
                return .right
            case .south:
                return .uturn
            case .west:
                return .left
            }
        case .east:
            switch self {
            case .north:
                return .left
            case .east:
                return TurnDirection.none
            case .south:
                return .right
            case .west:
                return .uturn
            }
        case .south:
            switch self {
            case .north:
                return .uturn
            case .east:
                return .left
            case .south:
                return TurnDirection.none
            case .west:
                return .right
            }
        case .west:
            switch self {
            case .north:
                return .right
            case .east:
                return .uturn
            case .south:
                return .left
            case .west:
                return TurnDirection.none
            }
        }

    }
}
