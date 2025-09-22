import SwiftUI

// MARK: - Simplified TabBar Example
struct ComponentStyleExample: View {
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
    @State private var showTabBar = true
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Main content area with default styling
                ItauSwiftUI.TabBar(
                    dataSource: dataSource,
                    delegate: tabBarDelegate,
                    isAnimated: true
                )
                .onAppear {
                    dataSource.state = showTabBar ? .visible : .hidden
                }
                .onChange(of: showTabBar) { newValue in
                    dataSource.state = newValue ? .visible : .hidden
                }
                
                // Control panel
                ControlPanel(
                    dataSource: dataSource,
                    showTabBar: $showTabBar
                )
            }
            .navigationTitle("TabBar Example")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Simplified Control Panel
struct ControlPanel: View {
    @ObservedObject var dataSource: MockTabBarDataSource
    @Binding var showTabBar: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Divider()
            
            VStack(spacing: 12) {
                Text("TabBar Controls")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Environment controls
                HStack(spacing: 16) {
                    Button("Toggle TabBar") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTabBar.toggle()
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


// MARK: - Preview
struct ComponentStyleExample_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ComponentStyleExample()
                .previewDisplayName("TabBar Example")
            
            ComponentStyleExample()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
