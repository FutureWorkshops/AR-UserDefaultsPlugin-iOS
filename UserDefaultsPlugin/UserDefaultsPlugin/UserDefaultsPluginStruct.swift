//
//  UserDefaultsPlugin.swift
//  UserDefaultsPlugin
//
//

import Foundation
import MobileWorkflowCore

public struct UserDefaultsPluginStruct: Plugin {
    public static var allStepsTypes: [StepType] {
        return UserDefaultsStepType.allCases
    }
}

enum UserDefaultsStepType: String, StepType, CaseIterable {
    case step1 = "io.app-rail.userdefaults.save-default"
    
    var typeName: String {
        return self.rawValue
    }
    
    var stepClass: BuildableStep.Type {
        switch self {
        case .step1: return SaveDefaultStep.self
        }
    }
}

