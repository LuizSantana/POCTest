import Foundation
import SwiftUI

// MARK: - TabBar Item Model
struct TabBarItem: Identifiable, Equatable, Hashable {
    let id: String
    let identifier: String
    let title: String?
    let icon: String
    let deeplink: String
    let modal: Bool?
    let analytics: String
    
    init(
        identifier: String,
        title: String? = nil,
        icon: String,
        deeplink: String,
        modal: Bool? = nil,
        analytics: String
    ) {
        self.id = identifier
        self.identifier = identifier
        self.title = title
        self.icon = icon
        self.deeplink = deeplink
        self.modal = modal
        self.analytics = analytics
    }
}

// MARK: - TabBar State
enum TabBarState {
    case visible
    case hidden
    
    var isVisible: Bool {
        self == .visible
    }
}

// MARK: - TabBar Selection
struct TabBarSelection {
    let item: TabBarItem
    let timestamp: Date
    
    init(item: TabBarItem) {
        self.item = item
        self.timestamp = Date()
    }
}

// MARK: - TabBar Actions
enum TabBarAction {
    case resetNavigationStack
    case present
    case push
}

// MARK: - TabBar Delegate
protocol TabBarDelegate: AnyObject {
    func tabBar(_ tabBar: any View, didSelectItem item: TabBarItem)
    func tabBar(_ tabBar: any View, didPerformAction action: TabBarAction, for item: TabBarItem)
}

// MARK: - TabBar Configuration
struct TabBarConfiguration {
    let items: [TabBarItem]
    let selectedItem: TabBarItem?
    let state: TabBarState
    let onItemSelected: (TabBarItem) -> Void
    let onStateChanged: (TabBarState) -> Void
}