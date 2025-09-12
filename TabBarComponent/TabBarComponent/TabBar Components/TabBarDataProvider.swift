import Foundation
import Combine
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - TabBar Data Provider Protocol
protocol TabBarDataProvider: AnyObject {
    func items() -> [TabBarItem]
    func action(for tabItem: TabBarItem) -> TabBarAction?
    #if canImport(UIKit)
    func controller(for tabItem: TabBarItem) -> UIViewController?
    #else
    func controller(for tabItem: TabBarItem) -> Any?
    #endif
}


// MARK: - Mock TabBar Data Provider
class MockTabBarDataProvider: TabBarDataProvider, ObservableObject {
    @Published private var _items: [TabBarItem] = []
    @Published private var selectedItem: TabBarItem?
    @Published private var state: TabBarState = .visible
    
    init(items: [TabBarItem] = [], selectedItem: TabBarItem? = nil) {
        self._items = items
        self.selectedItem = selectedItem
    }
    
    // MARK: - TabBarDataProvider Protocol
    func items() -> [TabBarItem] {
        return _items
    }
    
    func action(for tabItem: TabBarItem) -> TabBarAction? {
        // Mock implementation
        return .push
    }
    
    #if canImport(UIKit)
    func controller(for tabItem: TabBarItem) -> UIViewController? {
        // Mock implementation
        let viewController = UIHostingController(rootView: TabContentView(item: tabItem))
        viewController.title = tabItem.title
        return viewController
    }
    #else
    func controller(for tabItem: TabBarItem) -> Any? {
        return nil
    }
    #endif
    
    // MARK: - Additional Methods for TabBar Integration
    func updateItems(_ items: [TabBarItem]) {
        self._items = items
    }
    
    func selectItem(_ item: TabBarItem) {
        self.selectedItem = item
    }
    
    func setState(_ state: TabBarState) {
        self.state = state
    }
    
    // MARK: - Computed Properties for State Access
    var currentState: TabBarState {
        return state
    }
}

// MARK: - Default TabBar Data Provider
class DefaultTabBarDataProvider: TabBarDataProvider, ObservableObject {
    @Published private var _items: [TabBarItem] = []
    @Published private var selectedItem: TabBarItem?
    @Published private var state: TabBarState = .visible
    
    init(items: [TabBarItem] = [], selectedItem: TabBarItem? = nil) {
        self._items = items
        self.selectedItem = selectedItem
    }
    
    // MARK: - TabBarDataProvider Protocol
    func items() -> [TabBarItem] {
        return _items
    }
    
    func action(for tabItem: TabBarItem) -> TabBarAction? {
        // Default implementation
        return .push
    }
    
    #if canImport(UIKit)
    func controller(for tabItem: TabBarItem) -> UIViewController? {
        // Default implementation
        let viewController = UIHostingController(rootView: TabContentView(item: tabItem))
        viewController.title = tabItem.title
        return viewController
    }
    #else
    func controller(for tabItem: TabBarItem) -> Any? {
        return nil
    }
    #endif
    
    // MARK: - Additional Methods for TabBar Integration
    func updateItems(_ items: [TabBarItem]) {
        self._items = items
    }
    
    func selectItem(_ item: TabBarItem) {
        self.selectedItem = item
    }
    
    func setState(_ state: TabBarState) {
        self.state = state
    }
    
    // MARK: - Computed Properties for State Access
    var currentState: TabBarState {
        return state
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