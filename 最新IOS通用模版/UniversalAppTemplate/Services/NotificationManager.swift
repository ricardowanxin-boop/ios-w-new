import Foundation

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published private(set) var lastBannerMessage: String?

    private init() {}

    func publish(_ message: String) {
        lastBannerMessage = message
    }

    func clear() {
        lastBannerMessage = nil
    }
}
