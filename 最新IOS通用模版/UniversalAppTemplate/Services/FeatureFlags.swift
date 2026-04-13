import Foundation
import SwiftUI

@MainActor
final class FeatureFlagStore: ObservableObject {
    @Published var flags: FeatureFlags {
        didSet {
            guard flags != oldValue else { return }
            SharedDefaults.saveFeatureFlags(flags)
        }
    }

    init() {
        flags = SharedDefaults.loadFeatureFlags()
    }

    func reset() {
        flags = FeatureFlags()
    }
}
