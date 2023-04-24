//
//  LoadDefaultStep.swift
//  UserDefaultsPlugin
//
//

import Foundation
import MobileWorkflowCore
import SwiftUI

public class LoadDefaultStep: ObservableStep, BuildableStepWithMetadata {
    public let properties: UserDefaultsLoadDefaultMetadata

    public required init(properties: UserDefaultsLoadDefaultMetadata, session: Session, services: StepServices) {
        self.properties = properties
        super.init(identifier: properties.id, session: session, services: services)
    }

    public override func instantiateViewController() -> StepViewController {
        LoadDefaultStepViewController(step: self)
    }
}

public class LoadDefaultStepViewController: MWLoadingStepViewController {
    public override var titleMode: StepViewControllerTitleMode { .smallTitle }
    var loadDefaultStep: LoadDefaultStep { self.step as! LoadDefaultStep }
    var interval: Int = 1
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UserDefaults.standard.string(forKey: self.loadDefaultStep.properties.key)
        self.loadDefaultStep.navigator.continue(storing: value)
        self.isLoading = true
        Timer.scheduledTimer(withTimeInterval: TimeInterval(self.interval), repeats: false) { [weak self] _ in
            self?.isLoading = false
            self?.goForward()
        }
    }
    
}

public class UserDefaultsLoadDefaultMetadata: StepMetadata {
    enum CodingKeys: String, CodingKey {
        case key
    }

    let key: String

    init(id: String, title: String, key: String, next: PushLinkMetadata?, links: [LinkMetadata]) {
        self.key = key
        super.init(id: id, type: "io.app-rail.userdefaults.load-default", title: title, next: next, links: links)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.key, forKey: .key)
        try super.encode(to: encoder)
    }
}

public extension StepMetadata {
    static func userDefaultsLoadDefault(id: String, title: String, key: String, next: PushLinkMetadata? = nil, links: [LinkMetadata] = []) -> UserDefaultsLoadDefaultMetadata {
        UserDefaultsLoadDefaultMetadata(
            id: id,
            title: title,
            key: key,
            next: next,
            links: links
        )
    }
}

