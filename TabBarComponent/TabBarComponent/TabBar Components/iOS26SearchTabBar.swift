import SwiftUI
import UIKit
import IDSDesignSystem

// MARK: - iOS 26 Search TabBar Configuration
@available(iOS 26.0, *)
struct iOS26SearchTabBarConfiguration {
    let searchPlaceholder: String
    let searchEnabled: Bool
    let searchDelegate: SearchTabBarDelegate?
    
    init(
        searchPlaceholder: String = "Search...",
        searchEnabled: Bool = true,
        searchDelegate: SearchTabBarDelegate? = nil
    ) {
        self.searchPlaceholder = searchPlaceholder
        self.searchEnabled = searchEnabled
        self.searchDelegate = searchDelegate
    }
}

// MARK: - Search TabBar Delegate
@available(iOS 26.0, *)
protocol SearchTabBarDelegate: AnyObject {
    func searchTabBar(_ tabBar: any View, didSearch query: String)
    func searchTabBar(_ tabBar: any View, didClearSearch: Bool)
    func searchTabBar(_ tabBar: any View, didSelectSearchSuggestion suggestion: String)
}

// MARK: - iOS 26 Search TabBar
@available(iOS 26.0, *)
struct iOS26SearchTabBar: View {
    let configuration: iOS26SearchTabBarConfiguration
    let dataSource: TabBarDataSource
    let delegate: TabBarDelegate?
    
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false
    @State private var searchSuggestions: [String] = []
    
    init(
        configuration: iOS26SearchTabBarConfiguration,
        dataSource: TabBarDataSource,
        delegate: TabBarDelegate? = nil
    ) {
        self.configuration = configuration
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar (iOS 26 style)
            if configuration.searchEnabled {
                searchBarView
            }
            
            // Main TabBar
            ItauSwiftUI.TabBar(
                dataSource: dataSource as! MockTabBarDataSource,
                delegate: delegate
            )
        }
    }
    
    @ViewBuilder
    private var searchBarView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                // Search Icon
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16, weight: .medium))
                
                // Search TextField
                TextField(
                    configuration.searchPlaceholder,
                    text: $searchText
                )
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16))
                .onSubmit {
                    performSearch()
                }
                .onChange(of: searchText) { newValue in
                    handleSearchTextChange(newValue)
                }
                
                // Clear Button
                if !searchText.isEmpty {
                    Button(action: clearSearch) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(searchBarBackground)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Search Suggestions
            if isSearchActive && !searchSuggestions.isEmpty {
                searchSuggestionsView
            }
        }
        .background(Color(.systemBackground))
    }
    
    @ViewBuilder
    private var searchBarBackground: some View {
        switch configuration.searchStyle {
        case .default:
            Color(.systemGray6)
        case .compact:
            Color(.systemGray5)
        case .expanded:
            Color(.systemGray6)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        case .floating:
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
    }
    
    @ViewBuilder
    private var searchSuggestionsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(searchSuggestions, id: \.self) { suggestion in
                Button(action: {
                    selectSuggestion(suggestion)
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                        
                        Text(suggestion)
                            .foregroundColor(.primary)
                            .font(.system(size: 16))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .buttonStyle(PlainButtonStyle())
                
                if suggestion != searchSuggestions.last {
                    Divider()
                        .padding(.leading, 48)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Search Actions
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isSearchActive = true
        delegate?.tabBar(ItauSwiftUI.TabBar(dataSource: dataSource as! MockTabBarDataSource), didSelectItem: TabBarItem(
            identifier: "search",
            title: "Search",
            icon: "magnifyingglass",
            deeplink: "app://search?query=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
            modal: false,
            analytics: "search_query:\(searchText)"
        ))
        
        configuration.searchDelegate?.searchTabBar(
            ItauSwiftUI.TabBar(dataSource: dataSource as! MockTabBarDataSource),
            didSearch: searchText
        )
    }
    
    private func clearSearch() {
        searchText = ""
        isSearchActive = false
        searchSuggestions = []
        
        configuration.searchDelegate?.searchTabBar(
            ItauSwiftUI.TabBar(dataSource: dataSource as! MockTabBarDataSource),
            didClearSearch: true
        )
    }
    
    private func handleSearchTextChange(_ newValue: String) {
        if newValue.isEmpty {
            isSearchActive = false
            searchSuggestions = []
        } else {
            // Generate search suggestions based on tab items
            generateSearchSuggestions(for: newValue)
        }
    }
    
    private func selectSuggestion(_ suggestion: String) {
        searchText = suggestion
        performSearch()
        
        configuration.searchDelegate?.searchTabBar(
            ItauSwiftUI.TabBar(dataSource: dataSource as! MockTabBarDataSource),
            didSelectSearchSuggestion: suggestion
        )
    }
    
    private func generateSearchSuggestions(for query: String) {
        let allItems = dataSource.itens()
        let suggestions: [String] = allItems.compactMap { item in
            guard let title = item.title,
                  title.localizedCaseInsensitiveContains(query) else { return nil }
            return title
        }
        
        searchSuggestions = Array(suggestions.prefix(5))
        isSearchActive = !suggestions.isEmpty
    }
}

// MARK: - iOS 26 Search TabBar Factory
@available(iOS 26.0, *)
struct iOS26SearchTabBarFactory {
    static func createSearchTabBar(
        with configuration: iOS26SearchTabBarConfiguration,
        dataSource: TabBarDataSource,
        delegate: TabBarDelegate? = nil
    ) -> some View {
        iOS26SearchTabBar(
            configuration: configuration,
            dataSource: dataSource,
            delegate: delegate
        )
    }
    
    static func createDefaultSearchConfiguration() -> iOS26SearchTabBarConfiguration {
        return iOS26SearchTabBarConfiguration(
            searchPlaceholder: "Search tabs...",
            searchEnabled: true
        )
    }
}

// MARK: - iOS 26 Search TabBar Register Extension
@available(iOS 26.0, *)
extension SwiftUITabBarRegister {
    func getSearchTabBarController(with parameters: [String: Any]?) throws -> UIViewController {
        let config = try parseSearchParameters(parameters)
        let dataSource = MockTabBarDataSource(itens: config.items)
        let delegate = SimpleTabBarDelegate()
        
        let searchConfig = iOS26SearchTabBarConfiguration(
            searchPlaceholder: config.searchPlaceholder,
            searchEnabled: config.searchEnabled,
            searchStyle: config.searchStyle
        )
        
        let searchTabBar = iOS26SearchTabBar(
            configuration: searchConfig,
            dataSource: dataSource,
            delegate: delegate
        )
        
        let hostingController = UIHostingController(rootView: searchTabBar)
        return hostingController
    }
    
    private func parseSearchParameters(_ parameters: [String: Any]?) throws -> SearchTabBarConfiguration {
        guard let params = parameters else {
            return createDefaultSearchConfiguration()
        }
        
        let items = try parseSearchItems(from: params)
        let searchPlaceholder = params["searchPlaceholder"] as? String ?? "Search tabs..."
        let searchEnabled = params["searchEnabled"] as? Bool ?? true
        
        return SearchTabBarConfiguration(
            items: items,
            searchPlaceholder: searchPlaceholder,
            searchEnabled: searchEnabled
        )
    }
    
    private func parseSearchItems(from parameters: [String: Any]) throws -> [TabBarItem] {
        guard let itemsData = parameters["items"] as? [[String: Any]] else {
            return TabBarItemFactory.createDefaultItens()
        }
        
        return itemsData.compactMap { itemData in
            guard let identifier = itemData["identifier"] as? String,
                  let icon = itemData["icon"] as? String,
                  let deeplink = itemData["deeplink"] as? String else {
                return nil
            }
            
            return TabBarItem(
                identifier: identifier,
                title: itemData["title"] as? String,
                icon: icon,
                deeplink: deeplink,
                modal: itemData["modal"] as? Bool,
                analytics: itemData["analytics"] as? String ?? ""
            )
        }
    }
    
    private func createDefaultSearchConfiguration() -> SearchTabBarConfiguration {
        return SearchTabBarConfiguration(
            items: TabBarItemFactory.createDefaultItens(),
            searchPlaceholder: "Search tabs...",
            searchEnabled: true
        )
    }
}

// MARK: - Simple TabBar Delegate
@available(iOS 26.0, *)
private class SimpleTabBarDelegate: TabBarDelegate {
    func tabBar(_ tabBar: any View, didSelectItem item: TabBarItem) {
        print("Simple TabBar delegate: Selected item \(item.title ?? item.identifier)")
    }
    
    func tabBar(_ tabBar: any View, didPerformAction action: TabBarAction, for item: TabBarItem) {
        print("Simple TabBar delegate: Performed action \(action) for item \(item.title ?? item.identifier)")
    }
    
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController? {
        return nil
    }
    
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView? {
        return nil
    }
}

// MARK: - Search TabBar Configuration
@available(iOS 26.0, *)
private struct SearchTabBarConfiguration {
    let items: [TabBarItem]
    let searchPlaceholder: String
    let searchEnabled: Bool
}
