import Foundation
import Observation

@Observable
final class FeedViewModel {
    var items: [FeedItem] = []
    var lastError: String?
    private var timer: Timer?
    private let api: FeedAPI

    init(api: FeedAPI) {
        self.api = api
    }

    func startAutoRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            self.reload()
        }
    }

    func reload() {
        Task.detached {
            do {
                let result = try await self.api.fetchFeed()
                self.items = result
            } catch {
                self.lastError = error.localizedDescription
            }
        }
    }

    func openItem(at index: Int) -> URL {
        URL(string: items[index].link)!
    }
}
