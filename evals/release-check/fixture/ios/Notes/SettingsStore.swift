import Foundation

struct SettingsStore {
    private let defaults = UserDefaults.standard

    var sortByDate: Bool {
        get { defaults.bool(forKey: "sortByDate") }
        nonmutating set { defaults.set(newValue, forKey: "sortByDate") }
    }
}
