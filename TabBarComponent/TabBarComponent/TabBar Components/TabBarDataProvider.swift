import Foundation
import Combine
import SwiftUI
import UIKit

// MARK: - TabBar Data Source Protocol
protocol TabBarDataSource: AnyObject {
    func itens() -> [TabBarItem]
    func action(for tabItem: TabBarItem) -> TabBarAction?
    func controller(for tabItem: TabBarItem) -> UIViewController?
    func view(for tabItem: TabBarItem) -> AnyView?
}


// MARK: - Mock TabBar Data Source
class MockTabBarDataSource: TabBarDataSource, ObservableObject {
    @Published var _itens: [TabBarItem] = []
    @Published var selectedItem: TabBarItem?
    @Published var state: TabBarState = .visible
    
    init(itens: [TabBarItem] = [], selectedItem: TabBarItem? = nil) {
        self._itens = itens
        self.selectedItem = selectedItem
    }
    
    // MARK: - TabBarDataSource Protocol
    func itens() -> [TabBarItem] {
        return _itens
    }
    
    func action(for tabItem: TabBarItem) -> TabBarAction? {
        // Mock implementation
        return .push
    }
    
    func controller(for tabItem: TabBarItem) -> UIViewController? {
        // Mock implementation - return nil to use SwiftUI fallback
        return nil
    }
    
    func view(for tabItem: TabBarItem) -> AnyView? {
        // Mock implementation - return nil to use delegate fallback
        return nil
    }
    
    // MARK: - Computed Properties for State Access
    var currentState: TabBarState {
        return state
    }
}

// MARK: - Default TabBar Data Source
class DefaultTabBarDataSource: TabBarDataSource, ObservableObject {
    @Published var _itens: [TabBarItem] = []
    @Published var selectedItem: TabBarItem?
    @Published var state: TabBarState = .visible
    
    init(itens: [TabBarItem] = [], selectedItem: TabBarItem? = nil) {
        self._itens = itens
        self.selectedItem = selectedItem
    }
    
    // MARK: - TabBarDataSource Protocol
    func itens() -> [TabBarItem] {
        return _itens
    }
    
    func action(for tabItem: TabBarItem) -> TabBarAction? {
        // Default implementation
        return .push
    }
    
    func controller(for tabItem: TabBarItem) -> UIViewController? {
        // Default implementation - return nil to use SwiftUI fallback
        return nil
    }
    
    func view(for tabItem: TabBarItem) -> AnyView? {
        // Default implementation - return nil to use delegate fallback
        return nil
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
    
    static func createDefaultItens() -> [TabBarItem] {
        [
            createHomeItem(),
            createSearchItem(),
            createFavoritesItem(),
            createProfileItem()
        ]
    }
    
    static func createExtendedItens() -> [TabBarItem] {
        [
            createHomeItem(),
            createSearchItem(),
            createFavoritesItem(),
            createProfileItem(),
            createSettingsItem()
        ]
    }
}