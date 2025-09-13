import SwiftUI

// MARK: - TabBar Example Usage
struct TabBarExample: View {
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
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
                    dataSource: dataSource,
                    delegate: tabBarDelegate,
                    isAnimated: true
                )
                
                // Control buttons
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        Button("Show TabBar") {
                            dataSource.state = .visible
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Hide TabBar") {
                            dataSource.state = .hidden
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
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        TabView {
            // Default Style
            ItauSwiftUI.TabBar(
                style: DefaultTabBarStyle(),
                dataSource: dataSource,
                delegate: tabBarDelegate,
                isAnimated: true
            )
            .tabItem {
                Label("Default", systemImage: "rectangle.3.group")
            }
            
            // Compact Style
            ItauSwiftUI.TabBar(
                style: CompactTabBarStyle(),
                dataSource: dataSource,
                delegate: tabBarDelegate,
                isAnimated: true
            )
            .tabItem {
                Label("Compact", systemImage: "rectangle.compress.vertical")
            }
            
            // Floating Style
            ItauSwiftUI.TabBar(
                style: FloatingTabBarStyle(),
                dataSource: dataSource,
                delegate: tabBarDelegate,
                isAnimated: true
            )
            .tabItem {
                Label("Floating", systemImage: "circle.hexagongrid")
            }
            
            // Minimal Style
            ItauSwiftUI.TabBar(
                style: MinimalTabBarStyle(),
                dataSource: dataSource,
                delegate: tabBarDelegate,
                isAnimated: true
            )
            .tabItem {
                Label("Minimal", systemImage: "minus.circle")
            }
        }
    }
}

// MARK: - Composable Style Example
struct ComposableStyleExample: View {
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        ItauSwiftUI.TabBar(
            style: DefaultTabBarStyle()
                .background(Color.blue.opacity(0.1), cornerRadius: 20)
                .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
                .padding(horizontal: 20, vertical: 12),
            dataSource: dataSource,
            delegate: tabBarDelegate,
            isAnimated: true
        )
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
