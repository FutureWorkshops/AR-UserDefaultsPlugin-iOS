//
//  LoadDefaultStep.swift
//  UserDefaultsPlugin
//
//

import Foundation
import MobileWorkflowCore
import SwiftUI

public class LoadDefaultStep: ObservableStep {
    let key: String

    public init(identifier: String, session: Session, services: StepServices, key: String) {
        self.key = key
        super.init(identifier: identifier, session: session, services: services)
    }

    public override func instantiateViewController() -> StepViewController {
        LoadDefaultStepViewController(step: self)
    }
}

extension LoadDefaultStep: BuildableStep {

    public static var mandatoryCodingPaths: [CodingKey] {
        ["key"]
    }

    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        guard let key = stepInfo.data.content["key"] as? String else {
            throw ParseError.invalidStepData(cause: "Mandatory key property not found")
        }
        
        return LoadDefaultStep(identifier: stepInfo.data.identifier, session: stepInfo.session, services: services, key: key)
    }
}

public class LoadDefaultStepViewController: MWLoadingStepViewController {
    public override var titleMode: StepViewControllerTitleMode { .smallTitle }
    var loadDefaultStep: LoadDefaultStep { self.step as! LoadDefaultStep }
    var interval: Int = 1
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UserDefaults.standard.string(forKey: self.loadDefaultStep.key)
        self.loadDefaultStep.navigator.continue(storing: value)
        self.isLoading = true
        Timer.scheduledTimer(withTimeInterval: TimeInterval(self.interval), repeats: false) { [weak self] _ in
            self?.isLoading = false
            self?.goForward()
        }
    }
    
}


