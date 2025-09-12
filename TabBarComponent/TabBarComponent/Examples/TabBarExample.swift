import SwiftUI

// MARK: - TabBar Example Usage
struct TabBarExample: View {
    @State private var dataProvider = MockTabBarDataProvider(items: TabBarItemFactory.createDefaultItems())
    @State private var showTabBar = true
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        NavigationView {
            VStack {
                // Content area
                ItauSwiftUI.TabBar(
                    style: DefaultTabBarStyle()
                        .background(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -4),
                    dataProvider: dataProvider,
                    delegate: tabBarDelegate,
                    isAnimated: true
                ) { item in
                    TabContentView(item: item)
                }
                
                // Control buttons
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        Button("Show TabBar") {
                            dataProvider.setState(.visible)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Hide TabBar") {
                            dataProvider.setState(.hidden)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    HStack(spacing: 16) {
                        Button("Default Style") {
                            // Switch to default style
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Compact Style") {
                            // Switch to compact style
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Floating Style") {
                            // Switch to floating style
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
            .navigationTitle("TabBar Example")
        }
    }
}


// MARK: - Multiple Style Examples
struct TabBarStyleExamples: View {
    @State private var dataProvider = MockTabBarDataProvider(items: TabBarItemFactory.createDefaultItems())
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        TabView {
            // Default Style
            ItauSwiftUI.TabBar(
                style: DefaultTabBarStyle(),
                dataProvider: dataProvider,
                delegate: tabBarDelegate,
                isAnimated: true
            ) { item in
                TabContentView(item: item)
            }
            .tabItem {
                Label("Default", systemImage: "rectangle.3.group")
            }
            
            // Compact Style
            ItauSwiftUI.TabBar(
                style: CompactTabBarStyle(),
                dataProvider: dataProvider,
                delegate: tabBarDelegate,
                isAnimated: true
            ) { item in
                TabContentView(item: item)
            }
            .tabItem {
                Label("Compact", systemImage: "rectangle.compress.vertical")
            }
            
            // Floating Style
            ItauSwiftUI.TabBar(
                style: FloatingTabBarStyle(),
                dataProvider: dataProvider,
                delegate: tabBarDelegate,
                isAnimated: true
            ) { item in
                TabContentView(item: item)
            }
            .tabItem {
                Label("Floating", systemImage: "circle.hexagongrid")
            }
            
            // Minimal Style
            ItauSwiftUI.TabBar(
                style: MinimalTabBarStyle(),
                dataProvider: dataProvider,
                delegate: tabBarDelegate,
                isAnimated: true
            ) { item in
                TabContentView(item: item)
            }
            .tabItem {
                Label("Minimal", systemImage: "minus.circle")
            }
        }
    }
}

// MARK: - Composable Style Example
struct ComposableStyleExample: View {
    @State private var dataProvider = MockTabBarDataProvider(items: TabBarItemFactory.createDefaultItems())
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        ItauSwiftUI.TabBar(
            style: DefaultTabBarStyle()
                .background(Color.blue.opacity(0.1), cornerRadius: 20)
                .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
                .padding(horizontal: 20, vertical: 12),
            dataProvider: dataProvider,
            delegate: tabBarDelegate,
            isAnimated: true
        ) { item in
            TabContentView(item: item)
        }
    }
}

// MARK: - Preview
struct TabBarExample_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarExample()
                .previewDisplayName("Basic Example")
            
            TabBarStyleExamples()
                .previewDisplayName("Style Examples")
            
            ComposableStyleExample()
                .previewDisplayName("Composable Style")
        }
    }
}
