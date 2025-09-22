import SwiftUI
import UIKit
import IDSDesignSystem

// MARK: - SwiftUI TabBar Register
class SwiftUITabBarRegister {
    
    // MARK: - Configuration Keys
    private enum ConfigurationKeys {
        static let items = "items"
        static let selectedItem = "selectedItem"
        static let delegate = "delegate"
        static let isAnimated = "isAnimated"
        static let showTabBar = "showTabBar"
    }
    
    // MARK: - Public Methods
    
    /// Creates and configures an ItauSwiftUI.TabBar with the provided parameters
    /// - Parameter parameters: Dictionary containing configuration parameters
    /// - Returns: UIViewController containing the configured ItauSwiftUI.TabBar
    /// - Throws: SwiftUITabBarError for invalid parameters or configuration issues
    func getController(with parameters: [String: Any]?) throws -> Any {
        #if canImport(UIKit)
        let config = try parseParameters(parameters)
        let hostingController = createHostingController(with: config)
        return hostingController
        #else
        throw SwiftUITabBarError.missingRequiredParameter("UIKit not available")
        #endif
    }
    
    // MARK: - Private Methods
    
    private func parseParameters(_ parameters: [String: Any]?) throws -> RegisterTabBarConfiguration {
        guard let params = parameters else {
            return createDefaultConfiguration()
        }
        
        // Parse items
        let items = try parseItems(from: params)
        
        // Parse selected item
        let selectedItem = try parseSelectedItem(from: params, items: items)
        
        // Parse animation setting
        let isAnimated = parseBoolean(from: params, key: ConfigurationKeys.isAnimated, defaultValue: true)
        
        // Parse show tab bar setting
        let showTabBar = parseBoolean(from: params, key: ConfigurationKeys.showTabBar, defaultValue: true)
        
        return RegisterTabBarConfiguration(
            items: items,
            selectedItem: selectedItem,
            isAnimated: isAnimated,
            showTabBar: showTabBar
        )
    }
    
    private func parseItems(from parameters: [String: Any]) throws -> [TabBarItem] {
        guard let itemsData = parameters[ConfigurationKeys.items] as? [[String: Any]] else {
            // Return default items if none provided
            return TabBarItemFactory.createDefaultItens()
        }
        
        var items: [TabBarItem] = []
        for itemData in itemsData {
            let item = try createTabBarItem(from: itemData)
            items.append(item)
        }
        
        return items
    }
    
    private func createTabBarItem(from data: [String: Any]) throws -> TabBarItem {
        guard let identifier = data["identifier"] as? String else {
            throw SwiftUITabBarError.missingRequiredParameter("identifier")
        }
        
        let title = data["title"] as? String
        let icon = data["icon"] as? String ?? "circle.fill"
        let deeplink = data["deeplink"] as? String ?? ""
        let modal = data["modal"] as? Bool
        let analytics = data["analytics"] as? String ?? ""
        
        return TabBarItem(
            identifier: identifier,
            title: title,
            icon: icon,
            deeplink: deeplink,
            modal: modal,
            analytics: analytics
        )
    }
    
    private func parseSelectedItem(from parameters: [String: Any], items: [TabBarItem]) throws -> TabBarItem? {
        guard let selectedItemData = parameters[ConfigurationKeys.selectedItem] as? [String: Any] else {
            return items.first
        }
        
        let selectedItem = try createTabBarItem(from: selectedItemData)
        
        // Verify the selected item exists in the items array
        if items.contains(where: { $0.id == selectedItem.id }) {
            return selectedItem
        } else {
            return items.first
        }
    }
    
    
    private func parseBoolean(from parameters: [String: Any], key: String, defaultValue: Bool) -> Bool {
        return parameters[key] as? Bool ?? defaultValue
    }
    
    private func createDefaultConfiguration() -> RegisterTabBarConfiguration {
        return RegisterTabBarConfiguration(
            items: TabBarItemFactory.createDefaultItens(),
            selectedItem: nil,
            isAnimated: true,
            showTabBar: true
        )
    }
    
    private func createHostingController(with config: RegisterTabBarConfiguration) -> Any {
        #if canImport(UIKit)
        let dataSource = MockTabBarDataSource(itens: config.items)
        let delegate = RegisterTabBarDelegate()
        
        let tabBarView = ItauSwiftUI.TabBar(
            dataSource: dataSource,
            delegate: delegate,
            isAnimated: config.isAnimated
        )
        
        let hostingController = UIHostingController(rootView: tabBarView)
        hostingController.title = "TabBar"
        
        return hostingController
        #else
        fatalError("UIKit not available")
        #endif
    }
}

// MARK: - Register Configuration Structure
private struct RegisterTabBarConfiguration {
    let items: [TabBarItem]
    let selectedItem: TabBarItem?
    let isAnimated: Bool
    let showTabBar: Bool
}

// MARK: - Register TabBar Delegate
private class RegisterTabBarDelegate: NSObject, TabBarDelegate {
    func tabBar(_ tabBar: any View, didSelectItem item: TabBarItem) {
        print("TabBar delegate: Selected item \(item.title ?? item.id)")
    }
    
    func tabBar(_ tabBar: any View, didPerformAction action: TabBarAction, for item: TabBarItem) {
        print("TabBar delegate: Performed action \(action) for item \(item.title ?? item.id)")
    }
    
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController? {
        // Return nil to use SwiftUI fallback
        return nil
    }
    
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView? {
        // Return nil to use default fallback
        return nil
    }
}

// MARK: - Error Types
enum SwiftUITabBarError: Error, LocalizedError {
    case missingRequiredParameter(String)
    case invalidParameter(String)
    
    var errorDescription: String? {
        switch self {
        case .missingRequiredParameter(let parameter):
            return "Missing required parameter: \(parameter)"
        case .invalidParameter(let parameter):
            return "Invalid parameter: \(parameter)"
        }
    }
}
