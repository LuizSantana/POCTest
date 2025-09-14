import SwiftUI
import UIKit

// MARK: - iOS 26 Search TabBar Example
@available(iOS 26.0, *)
struct iOS26SearchTabBarExample: View {
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
    @State private var searchDelegate = ExampleSearchTabBarDelegate()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("iOS 26 Search TabBar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Enhanced tabbar with search functionality")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Search TabBar
                iOS26SearchTabBar(
                    configuration: iOS26SearchTabBarConfiguration(
                        searchPlaceholder: "Search tabs...",
                        searchEnabled: true,
                        searchStyle: .default,
                        searchDelegate: searchDelegate
                    ),
                    dataSource: dataSource,
                    delegate: searchDelegate
                )
                
                // Configuration Panel
                configurationPanel
                
                Spacer()
            }
            .navigationTitle("iOS 26 Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private var configurationPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Configuration")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                // Search Style Picker
                HStack {
                    Text("Search Style:")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Picker("Style", selection: $searchDelegate.searchStyle) {
                        Text("Default").tag(SearchTabBarStyle.default)
                        Text("Compact").tag(SearchTabBarStyle.compact)
                        Text("Expanded").tag(SearchTabBarStyle.expanded)
                        Text("Floating").tag(SearchTabBarStyle.floating)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 200)
                }
                .padding(.horizontal)
                
                // Search Enabled Toggle
                HStack {
                    Text("Search Enabled:")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Toggle("", isOn: $searchDelegate.searchEnabled)
                }
                .padding(.horizontal)
                
                // Search Placeholder Text
                HStack {
                    Text("Placeholder:")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    TextField("Search placeholder", text: $searchDelegate.searchPlaceholder)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

// MARK: - Example Search TabBar Delegate
@available(iOS 26.0, *)
class ExampleSearchTabBarDelegate: TabBarDelegate, SearchTabBarDelegate, ObservableObject {
    @Published var searchStyle: SearchTabBarStyle = .default
    @Published var searchEnabled: Bool = true
    @Published var searchPlaceholder: String = "Search tabs..."
    
    // MARK: - TabBarDelegate
    func tabBar(_ tabBar: any View, didSelectItem item: TabBarItem) {
        print("TabBar delegate: Selected item \(item.title ?? item.id)")
    }
    
    func tabBar(_ tabBar: any View, didPerformAction action: TabBarAction, for item: TabBarItem) {
        print("TabBar delegate: Performed action \(action) for item \(item.title ?? item.id)")
    }
    
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController? {
        return nil // Use SwiftUI fallback
    }
    
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView? {
        return nil // Use default fallback
    }
    
    // MARK: - SearchTabBarDelegate
    func searchTabBar(_ tabBar: any View, didSearch query: String) {
        print("Search delegate: Searched for '\(query)'")
    }
    
    func searchTabBar(_ tabBar: any View, didClearSearch: Bool) {
        print("Search delegate: Cleared search")
    }
    
    func searchTabBar(_ tabBar: any View, didSelectSearchSuggestion suggestion: String) {
        print("Search delegate: Selected suggestion '\(suggestion)'")
    }
}

// MARK: - iOS 26 Search TabBar Preview
@available(iOS 26.0, *)
struct iOS26SearchTabBarExample_Previews: PreviewProvider {
    static var previews: some View {
        iOS26SearchTabBarExample()
    }
}

// MARK: - iOS 26 Search TabBar Usage Examples
@available(iOS 26.0, *)
struct iOS26SearchTabBarUsageExamples {
    
    // MARK: - Basic Usage
    static func basicUsage() -> some View {
        let dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
        let searchConfig = iOS26SearchTabBarConfiguration()
        
        return iOS26SearchTabBar(
            configuration: searchConfig,
            dataSource: dataSource
        )
    }
    
    // MARK: - Custom Configuration
    static func customConfiguration() -> some View {
        let dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
        let searchConfig = iOS26SearchTabBarConfiguration(
            searchPlaceholder: "Find your tab...",
            searchEnabled: true,
            searchStyle: .floating
        )
        
        return iOS26SearchTabBar(
            configuration: searchConfig,
            dataSource: dataSource
        )
    }
    
    // MARK: - With Custom Delegate
    static func withCustomDelegate() -> some View {
        let dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
        let delegate = ExampleSearchTabBarDelegate()
        let searchConfig = iOS26SearchTabBarConfiguration(
            searchPlaceholder: "Search with delegate...",
            searchEnabled: true,
            searchStyle: .expanded,
            searchDelegate: delegate
        )
        
        return iOS26SearchTabBar(
            configuration: searchConfig,
            dataSource: dataSource,
            delegate: delegate
        )
    }
    
    // MARK: - Factory Usage
    static func factoryUsage() -> some View {
        let dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
        let searchConfig = iOS26SearchTabBarFactory.createDefaultSearchConfiguration()
        
        return iOS26SearchTabBarFactory.createSearchTabBar(
            with: searchConfig,
            dataSource: dataSource
        )
    }
}
