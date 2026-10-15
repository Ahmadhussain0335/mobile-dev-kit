import Foundation

struct FeedItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let link: String
}
