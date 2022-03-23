import Foundation

public enum Migration {
    
    public static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    static var lastMigrationVersion: String {
        get {
            UserDefaults.standard.value(forKey: #function) as? String
            ?? UserDefaults.standard.value(forKey: "MTMigration.lastMigrationVersion") as? String
            ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: #function) }
    }

    public static func migrateToVersion(_ version: String, migrationBlock: () -> Void) {
        if (version.compare(lastMigrationVersion, options: .numeric) == .orderedDescending) &&
            (version.compare(appVersion, options: .numeric) != .orderedDescending) {
            migrationBlock()
            self.lastMigrationVersion = version
        }
    }
    
    public static func reset() {
        lastMigrationVersion = ""
    }
}
