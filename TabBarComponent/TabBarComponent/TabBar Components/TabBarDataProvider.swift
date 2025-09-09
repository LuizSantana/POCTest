import Foundation
import Combine

// MARK: - TabBar Data Provider Protocol
protocol TabBarDataProvider: AnyObject {
    func items() -> [TabBarItem]
    func action(for tabItem: TabBarItem) -> TabBarAction?
    func controller(for tabItem: TabBarItem) -> UIViewController?
}

// MARK: - Default TabBar Data Provider
class DefaultTabBarDataProvider: TabBarDataProvider, ObservableObject {
    @Published var items: [TabBarItem] = []
    @Published var selectedItem: TabBarItem?
    @Published var state: TabBarState = .visible
    
    weak var delegate: TabBarDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    init(items: [TabBarItem] = [], selectedItem: TabBarItem? = nil) {
        self.items = items
        self.selectedItem = selectedItem
        
        // Auto-select first item if none selected
        if selectedItem == nil && !items.isEmpty {
            self.selectedItem = items.first
        }
    }
    
    // MARK: - TabBarDataProvider Protocol
    func items() -> [TabBarItem] {
        return self.items
    }
    
    func action(for tabItem: TabBarItem) -> TabBarAction? {
        // Default implementation - can be overridden by subclasses
        switch tabItem.identifier {
        case "home":
            return .push
        case "search":
            return .present
        case "favorites":
            return .push
        case "profile":
            return .present
        case "settings":
            return .present
        default:
            return .push
        }
    }
    
    func controller(for tabItem: TabBarItem) -> UIViewController? {
        // Default implementation - can be overridden by subclasses
        let viewController = UIHostingController(rootView: TabContentView(item: tabItem))
        viewController.title = tabItem.title
        return viewController
    }
    
    // MARK: - Additional Methods for Internal Use
    func selectItem(_ item: TabBarItem) {
        selectedItem = item
        delegate?.tabBar(TabBar<AnyView>(), didSelectItem: item)
    }
    
    func setState(_ state: TabBarState) {
        self.state = state
    }
    
    func updateItems(_ items: [TabBarItem]) {
        self.items = items
        
        // Update selected item if it's no longer in the list
        if let currentSelected = selectedItem,
           !items.contains(where: { $0.id == currentSelected.id }) {
            selectedItem = items.first
        }
    }
    
    func performAction(_ action: TabBarAction, for item: TabBarItem) {
        delegate?.tabBar(TabBar<AnyView>(), didPerformAction: action, for: item)
    }
}

// MARK: - Mock TabBar Data Provider
class MockTabBarDataProvider: TabBarDataProvider, ObservableObject {
    @Published var items: [TabBarItem] = []
    @Published var selectedItem: TabBarItem?
    @Published var state: TabBarState = .visible
    
    private let onItemSelected: (TabBarItem) -> Void
    private let onStateChanged: (TabBarState) -> Void
    
    init(
        items: [TabBarItem] = [],
        selectedItem: TabBarItem? = nil,
        onItemSelected: @escaping (TabBarItem) -> Void = { _ in },
        onStateChanged: @escaping (TabBarState) -> Void = { _ in }
    ) {
        self.items = items
        self.selectedItem = selectedItem
        self.onItemSelected = onItemSelected
        self.onStateChanged = onStateChanged
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
    
    // MARK: - Additional Methods for Internal Use
    func selectItem(_ item: TabBarItem) {
        selectedItem = item
        onItemSelected(item)
    }
    
    func setState(_ state: TabBarState) {
        self.state = state
        onStateChanged(state)
    }
    
    func updateItems(_ items: [TabBarItem]) {
        self.items = items
    }
    
    func performAction(_ action: TabBarAction, for item: TabBarItem) {
        print("Mock: Performing action \(action) for item \(item.title ?? item.id)")
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