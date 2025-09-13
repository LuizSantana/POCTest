import SwiftUI

// MARK: - ComponentStyle Pattern Example
struct ComponentStyleExample: View {
    @State private var dataSource = MockTabBarDataSource(itens: TabBarItemFactory.createDefaultItens())
    @State private var selectedStyle: TabBarStyleType = .default
    @State private var showTabBar = true
    @State private var isDarkMode = false
    @StateObject private var tabBarDelegate = SampleTabBarDelegate()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Main content area with environment-based styling
                ItauSwiftUI.TabBar(
                    style: currentStyle,
                    dataSource: dataSource,
                    delegate: tabBarDelegate,
                    isAnimated: true
                )
                .environment(\.colorScheme, isDarkMode ? .dark : .light)
                .onAppear {
                    dataSource.state = showTabBar ? .visible : .hidden
                }
                .onChange(of: showTabBar) { newValue in
                    dataSource.state = newValue ? .visible : .hidden
                }
                
                // Control panel
                ControlPanel(
                    selectedStyle: $selectedStyle,
                        dataSource: dataSource,
                    showTabBar: $showTabBar,
                    isDarkMode: $isDarkMode
                )
            }
            .navigationTitle("ComponentStyle Pattern")
            .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Enhanced Control Panel
struct EnhancedControlPanel: View {
    @Binding var selectedStyle: TabBarStyleType
    @ObservedObject var dataSource: DefaultTabBarDataSource
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Divider()
            
            VStack(spacing: 12) {
                Text("ComponentStyle Controls")
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
                    Button("Toggle Dark Mode") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isDarkMode.toggle()
                        }
                    }
                    .buttonStyle(.bordered)
                    
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

// MARK: - Environment-Aware TabBar Style
struct EnvironmentAwareTabBarStyle: TabBarStyle {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    func makeBody(configuration: TabBarStyleConfiguration) -> some View {
        HStack(spacing: 0) {
            ForEach(configuration.items) { item in
                EnvironmentAwareTabBarItemView(
                    item: item,
                    isSelected: item.id == configuration.selectedItem?.id,
                    onTap: { configuration.onItemSelected(item) }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, horizontalSizeClass == .compact ? 8 : 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        )
        .opacity(configuration.state.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: configuration.state)
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground)
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.3) : .black.opacity(0.1)
    }
}

struct EnvironmentAwareTabBarItemView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let item: TabBarItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : itemColor)
                
                if let title = item.title {
                    Text(title)
                        .font(.caption2)
                        .foregroundColor(isSelected ? .accentColor : itemColor)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var itemColor: Color {
        colorScheme == .dark ? .white.opacity(0.8) : .primary
    }
}

extension TabBarStyle where Self == EnvironmentAwareTabBarStyle {
    static var environmentAware: EnvironmentAwareTabBarStyle { EnvironmentAwareTabBarStyle() }
}

// MARK: - Preview
struct ComponentStyleExample_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ComponentStyleExample()
                .previewDisplayName("ComponentStyle Example")
            
            ComponentStyleExample()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
