//
//  SaveDefaultStep.swift
//  UserDefaultsPlugin
//
//

import Foundation
import MobileWorkflowCore
import SwiftUI

public class SaveDefaultStep: ObservableStep, BuildableStepWithMetadata {
    public let properties: UserDefaultsSaveDefaultMetadata

    public required init(properties: UserDefaultsSaveDefaultMetadata, session: Session, services: StepServices) {
        self.properties = properties
        super.init(identifier: properties.id, session: session, services: services)
    }

    public override func instantiateViewController() -> StepViewController {
        SaveDefaultStepViewController(step: self)
    }
}

public class SaveDefaultStepViewController: MWLoadingStepViewController {
    public override var titleMode: StepViewControllerTitleMode { .smallTitle }
    var saveDefaultStep: SaveDefaultStep { self.step as! SaveDefaultStep }
    var interval: Int = 1
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let resolvedValue = self.saveDefaultStep.session.resolve(value: self.saveDefaultStep.properties.value)
        UserDefaults.standard.set(resolvedValue, forKey: self.saveDefaultStep.properties.key)
        
        self.isLoading = true
        Timer.scheduledTimer(withTimeInterval: TimeInterval(self.interval), repeats: false) { [weak self] _ in
            self?.isLoading = false
            self?.goForward()
        }
    }
    
}

public class UserDefaultsSaveDefaultMetadata: StepMetadata {
    enum CodingKeys: String, CodingKey {
        case key
        case value
    }

    let key: String
    let value: String

    init(id: String, title: String, key: String, value: String, next: PushLinkMetadata?, links: [LinkMetadata]) {
        self.key = key
        self.value = value
        super.init(id: id, type: "io.app-rail.userdefaults.save-default", title: title, next: next, links: links)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.value = try container.decode(String.self, forKey: .value)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.key, forKey: .key)
        try container.encode(self.value, forKey: .value)
        try super.encode(to: encoder)
    }
}

public extension StepMetadata {
    static func userDefaultsSaveDefault(id: String, title: String, key: String, value: String, next: PushLinkMetadata? = nil, links: [LinkMetadata] = []) -> UserDefaultsSaveDefaultMetadata {
        UserDefaultsSaveDefaultMetadata(
            id: id,
            title: title,
            key: key,
            value: value,
            next: next,
            links: links
        )
    }
}
