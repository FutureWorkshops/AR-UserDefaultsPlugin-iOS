//
//  SaveDefaultStep.swift
//  UserDefaultsPlugin
//
//

import Foundation
import MobileWorkflowCore
import SwiftUI

public class ResetDefaultsStep: ObservableStep {

    public override func instantiateViewController() -> StepViewController {
        ResetDefaultsStepViewController(step: self)
    }
}

extension ResetDefaultsStep: BuildableStep {

    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        return ResetDefaultsStep(identifier: stepInfo.data.identifier, session: stepInfo.session, services: services)
    }
}

public class ResetDefaultsStepViewController: MWLoadingStepViewController {
    public override var titleMode: StepViewControllerTitleMode { .smallTitle }
    var interval: Int = 1
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.resetStandardUserDefaults()
        self.isLoading = true
        Timer.scheduledTimer(withTimeInterval: TimeInterval(self.interval), repeats: false) { [weak self] _ in
            self?.isLoading = false
            self?.goForward()
        }
    }
    
}


