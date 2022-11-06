//
//  SaveDefaultStep.swift
//  UserDefaultsPlugin
//
//

import Foundation
import MobileWorkflowCore
import SwiftUI

public class SaveDefaultStep: ObservableStep {
    let key: String
    let value: String

    public init(identifier: String, session: Session, services: StepServices, key: String, value: String) {
        self.key = key
        self.value = value
        super.init(identifier: identifier, session: session, services: services)
    }

    public override func instantiateViewController() -> StepViewController {
        SaveDefaultStepViewController(step: self)
    }
}

extension SaveDefaultStep: BuildableStep {

    public static var mandatoryCodingPaths: [CodingKey] {
        ["key", "value"]
    }

    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        guard let value = stepInfo.data.content["value"] as? String else {
            throw ParseError.invalidStepData(cause: "Mandatory value property not found")
        }
        
        guard let key = stepInfo.data.content["key"] as? String else {
            throw ParseError.invalidStepData(cause: "Mandatory key property not found")
        }
        
        return SaveDefaultStep(identifier: stepInfo.data.identifier, session: stepInfo.session, services: services, key: key, value: value)
    }
}

public class SaveDefaultStepViewController: MWLoadingStepViewController {
    public override var titleMode: StepViewControllerTitleMode { .smallTitle }
    var saveDefaultStep: SaveDefaultStep { self.step as! SaveDefaultStep }
    var interval: Int = 1
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let resolvedValue = self.saveDefaultStep.session.resolve(value: self.saveDefaultStep.value)
        UserDefaults.standard.set(resolvedValue, forKey: self.saveDefaultStep.key)
        
        self.isLoading = true
        Timer.scheduledTimer(withTimeInterval: TimeInterval(self.interval), repeats: false) { [weak self] _ in
            self?.isLoading = false
            self?.goForward()
        }
    }
    
}


