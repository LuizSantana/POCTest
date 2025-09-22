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
                        Button("Toggle Animation") {
                            // Toggle animation
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Reset Selection") {
                            // Reset selection
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


// MARK: - Simple TabBar Example
struct SimpleTabBarExample: View {
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        ItauSwiftUI.TabBar(
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
            
            SimpleTabBarExample()
                .previewDisplayName("Simple Example")
        }
    }
}
