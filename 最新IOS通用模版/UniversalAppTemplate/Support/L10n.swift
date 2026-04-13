import Foundation

enum L10n {
    static func string(_ key: String) -> String {
        NSLocalizedString(key, bundle: .main, comment: "")
    }

    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: string(key), locale: .autoupdatingCurrent, arguments: arguments)
    }
}

extension String {
    var localized: String {
        L10n.string(self)
    }
}
