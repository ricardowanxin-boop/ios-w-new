import Foundation

enum BackgroundRefreshRegistration {
    static func registerIfNeeded() {}
}

actor BackgroundRefreshService {
    static let shared = BackgroundRefreshService()

    func schedule(force: Bool = false) async {}
}
