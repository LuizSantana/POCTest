import SwiftUI

// MARK: - Sample TabBar Delegate
class SampleTabBarDelegate: TabBarDelegate, ObservableObject {
    func tabBar(_ tabBar: any View, didSelectItem item: TabBarItem) {
        print("TabBar delegate: Selected item \(item.title ?? item.id)")
    }
    
    func tabBar(_ tabBar: any View, didPerformAction action: TabBarAction, for item: TabBarItem) {
        print("TabBar delegate: Performed action \(action) for item \(item.title ?? item.id)")
    }
    
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController? {
        // Return UIKit view controllers for specific tabs
        switch item.identifier {
        case "home":
            return HomeUIKitViewController(item: item)
        case "search":
            return UIHostingController(rootView: SearchView(item: item))
        case "profile":
            return ProfileUIKitViewController(item: item)
        default:
            return nil // Use SwiftUI fallback
        }
    }
    
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView? {
        // Create SwiftUI views for tabs that don't have UIKit controllers
        switch item.deeplink {
        case "app://favorites":
            return AnyView(FavoritesView(item: item))
        case "app://settings":
            return AnyView(SettingsView(item: item))
        default:
            // Return nil to use default fallback for other tabs
            return nil
        }
    }
}

struct ContentView: View {
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
    @State private var selectedStyle: TabBarStyleType = .default
    @State private var showTabBar = true
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Main content area
                ItauSwiftUI.TabBar(
                    style: currentStyle,
                    dataSource: dataSource,
                    delegate: tabBarDelegate,
                    isAnimated: true
                )
                
                // Control panel
                if showTabBar {
                    ControlPanel(
                        selectedStyle: $selectedStyle,
                        dataSource: dataSource,
                        showTabBar: $showTabBar
                    )
                }
            }
            .navigationTitle("TabBar Component")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(showTabBar ? "Hide Controls" : "Show Controls") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTabBar.toggle()
                        }
                    }
                }
            }
        }
    }
    
    private var currentStyle: any TabBarStyle {
        switch selectedStyle {
        case .default:
            return DefaultTabBarStyle()
        case .compact:
            return CompactTabBarStyle()
        case .floating:
            return FloatingTabBarStyle()
        case .minimal:
            return MinimalTabBarStyle()
        case .composable:
            return DefaultTabBarStyle()
                .background(Color.blue.opacity(0.1), cornerRadius: 20)
                .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
                .padding(horizontal: 20, vertical: 12)
        }
    }
}

enum TabBarStyleType: String, CaseIterable {
    case `default` = "Default"
    case compact = "Compact"
    case floating = "Floating"
    case minimal = "Minimal"
    case composable = "Composable"
}

struct ControlPanel: View {
    @Binding var selectedStyle: TabBarStyleType
    @ObservedObject var dataSource: MockTabBarDataSource
    @Binding var showTabBar: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Divider()
            
            VStack(spacing: 12) {
                Text("TabBar Controls")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Style selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Picker("Style", selection: $selectedStyle) {
                        ForEach(TabBarStyleType.allCases, id: \.self) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Environment controls
                HStack(spacing: 16) {
                    Button("Toggle TabBar") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dataSource.state = dataSource.currentState == TabBarState.visible ? TabBarState.hidden : TabBarState.visible
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                // Item controls
                HStack(spacing: 16) {
                    Button("Default Items") {
                        dataSource._itens = TabBarItemFactory.createDefaultItens()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Extended Items") {
                        dataSource._itens = TabBarItemFactory.createExtendedItens()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color(.systemGray6))
        }
    }
}

struct TabContentView: View {
    let item: TabBarItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: item.icon)
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.accentColor)
                    
                    Text(item.title ?? item.id.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("This is the content for \(item.title ?? item.id)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Item details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Item Details")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 8) {
                        DetailRow(label: "ID", value: item.id)
                        DetailRow(label: "Title", value: item.title ?? "None")
                        DetailRow(label: "Icon", value: item.icon)
                        DetailRow(label: "Deeplink", value: item.deeplink)
                        DetailRow(label: "Modal", value: item.modal?.description ?? "false")
                        DetailRow(label: "Analytics", value: item.analytics)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // Sample content
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sample Content")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("This is sample content for the \(item.title ?? item.id) tab. You can add any SwiftUI views here to demonstrate your tab content.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(0..<6) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.accentColor.opacity(0.1))
                                .frame(height: 80)
                                .overlay(
                                    VStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.accentColor)
                                        Text("Item \(index + 1)")
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                )
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.medium)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}
