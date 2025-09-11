import Foundation
import Combine
import SwiftUI
import UIKit

// MARK: - TabBar Data Provider Protocol
protocol TabBarDataProvider: AnyObject {
    func items() -> [TabBarItem]
    func action(for tabItem: TabBarItem) -> TabBarAction?
    func controller(for tabItem: TabBarItem) -> UIViewController?
}


// MARK: - Mock TabBar Data Provider
class MockTabBarDataProvider: TabBarDataProvider {
    private var items: [TabBarItem] = []
    
    init(items: [TabBarItem] = []) {
        self.items = items
    }
    
    // MARK: - TabBarDataProvider Protocol
    func items() -> [TabBarItem] {
        return self.items
    }
    
    func action(for tabItem: TabBarItem) -> TabBarAction? {
        // Mock implementation
        return .push
    }
    
    func controller(for tabItem: TabBarItem) -> UIViewController? {
        // Mock implementation
        let viewController = UIHostingController(rootView: TabContentView(item: tabItem))
        viewController.title = tabItem.title
        return viewController
    }
}

// MARK: - TabBar Item Factory
struct TabBarItemFactory {
    static func createHomeItem() -> TabBarItem {
        TabBarItem(
            identifier: "home",
            title: "Home",
            icon: "house.fill",
            deeplink: "app://home",
            modal: false,
            analytics: "tab_home_selected"
        )
    }
    
    static func createSearchItem() -> TabBarItem {
        TabBarItem(
            identifier: "search",
            title: "Search",
            icon: "magnifyingglass",
            deeplink: "app://search",
            modal: false,
            analytics: "tab_search_selected"
        )
    }
    
    static func createFavoritesItem() -> TabBarItem {
        TabBarItem(
            identifier: "favorites",
            title: "Favorites",
            icon: "heart.fill",
            deeplink: "app://favorites",
            modal: false,
            analytics: "tab_favorites_selected"
        )
    }
    
    static func createProfileItem() -> TabBarItem {
        TabBarItem(
            identifier: "profile",
            title: "Profile",
            icon: "person.fill",
            deeplink: "app://profile",
            modal: false,
            analytics: "tab_profile_selected"
        )
    }
    
    static func createSettingsItem() -> TabBarItem {
        TabBarItem(
            identifier: "settings",
            title: "Settings",
            icon: "gearshape.fill",
            deeplink: "app://settings",
            modal: true,
            analytics: "tab_settings_selected"
        )
    }
    
    static func createDefaultItems() -> [TabBarItem] {
        [
            createHomeItem(),
            createSearchItem(),
            createFavoritesItem(),
            createProfileItem()
        ]
    }
    
    static func createExtendedItems() -> [TabBarItem] {
        [
            createHomeItem(),
            createSearchItem(),
            createFavoritesItem(),
            createProfileItem(),
            createSettingsItem()
        ]
    }
}