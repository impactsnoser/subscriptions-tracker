import SwiftUI
import SwiftData

@main
struct SubscriptionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Subscription.self)
    }
}