import Foundation

final class SessionStore {
    private let defaults = UserDefaults.standard

    func save(accessToken: String, refreshToken: String) {
        defaults.set(accessToken, forKey: "accessToken")
        defaults.set(refreshToken, forKey: "refreshToken")
    }

    var refreshToken: String? {
        defaults.string(forKey: "refreshToken")
    }

    func clear() {
        defaults.removeObject(forKey: "accessToken")
        defaults.removeObject(forKey: "refreshToken")
    }
}
