//
//  SaveDefaultStep.swift
//  UserDefaultsPlugin
//
//

import Foundation
import MobileWorkflowCore
import SwiftUI

public class ResetDefaultsStep: ObservableStep, BuildableStepWithMetadata {
    public let properties: UserDefaultsResetDefaultsMetadata

    public required init(properties: UserDefaultsResetDefaultsMetadata, session: Session, services: StepServices) {
        self.properties = properties
        super.init(identifier: properties.id, session: session, services: services)
    }
    
    public override func instantiateViewController() -> StepViewController {
        ResetDefaultsStepViewController(step: self)
    }
}

public class ResetDefaultsStepViewController: MWLoadingStepViewController {
    public override var titleMode: StepViewControllerTitleMode { .smallTitle }
    var interval: Int = 1
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetDefaults()
        self.isLoading = true
        Timer.scheduledTimer(withTimeInterval: TimeInterval(self.interval), repeats: false) { [weak self] _ in
            self?.isLoading = false
            self?.goForward()
        }
    }
    
    private func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
}

public class UserDefaultsResetDefaultsMetadata: StepMetadata {
    init(id: String, title: String, next: PushLinkMetadata?, links: [LinkMetadata]) {
        super.init(id: id, type: "io.app-rail.userdefaults.reset-defaults", title: title, next: next, links: links)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

public extension StepMetadata {
    static func userDefaultsResetDefaults(id: String, title: String, next: PushLinkMetadata? = nil, links: [LinkMetadata] = []) -> UserDefaultsResetDefaultsMetadata {
        UserDefaultsResetDefaultsMetadata(
            id: id,
            title: title,
            next: next,
            links: links
        )
    }
}
