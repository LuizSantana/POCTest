import SwiftUI

// MARK: - ItauSwiftUI Namespace
struct ItauSwiftUI {
    // MARK: - TabBar Component (TabView-based)
    struct TabBar: View {
        private let dataSource: MockTabBarDataSource
        private let style: any TabBarStyle
        private let delegate: TabBarDelegate?
        private let isAnimated: Bool
        
        @State private var selectedItem: TabBarItem?
        
        init(
            style: any TabBarStyle,
            dataSource: MockTabBarDataSource,
            delegate: TabBarDelegate? = nil,
            isAnimated: Bool = true
        ) {
            self.style = style
            self.dataSource = dataSource
            self.delegate = delegate
            self.isAnimated = isAnimated
            self._selectedItem = State(initialValue: dataSource.itens().first)
        }
        
        var body: some View {
            VStack(spacing: 0) {
                TabView(selection: $selectedItem) {
                    ForEach(dataSource.itens()) { item in
                        createContentView(for: item)
                            .tabItem {
                                TabBarItemLabel(item: item)
                            }
                            .tag(item)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Custom TabBar styling overlay
                AnyView(style.makeBody(configuration: configuration))
            }
        .modifier(OnChangeModifier(
            value: selectedItem,
            action: { newValue in
                if let newValue = newValue {
                    delegate?.tabBar(self, didSelectItem: newValue)
                }
            }
        ))
        }
        
        private var configuration: TabBarStyleConfiguration {
            TabBarStyleConfiguration(
                items: dataSource.itens(),
                selectedItem: selectedItem,
                onItemSelected: { item in
                    selectedItem = item
                },
                state: .visible
            )
        }
        
        // MARK: - Dynamic Content Creation
        @ViewBuilder
        private func createContentView(for item: TabBarItem) -> some View {
            // First try to get a UIViewController from delegate
            if let viewController = delegate?.tabBar(self, controllerFor: item) {
                // Use UIKit view controller
                UIViewControllerWrapper(viewController: viewController)
            } else if let delegate = delegate, let customView = delegate.tabBar(self, createContentViewFor: item) {
                // Try to get a custom View from delegate
                customView
            } else {
                // Fallback to default SwiftUI view based on deeplink
                createDefaultSwiftUIView(for: item)
            }
        }
        
        @ViewBuilder
        private func createDefaultSwiftUIView(for item: TabBarItem) -> some View {
            switch item.deeplink {
            case "app://home":
                HomeView(item: item)
            case "app://search":
                SearchView(item: item)
            case "app://favorites":
                FavoritesView(item: item)
            case "app://profile":
                ProfileView(item: item)
            case "app://settings":
                SettingsView(item: item)
            default:
                DefaultTabContentView(item: item)
            }
        }
    }
}

// MARK: - UIViewController Wrapper
struct UIViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}

// MARK: - ItauSwiftUI Namespace Extension
extension ItauSwiftUI {
    // MARK: - TabBar Item Label
    struct TabBarItemLabel: View {
        let item: TabBarItem
        
        var body: some View {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                
                if let title = item.title {
                    Text(title)
                        .font(.caption2)
                }
            }
        }
    }
}

// MARK: - TabBar Modifiers
extension ItauSwiftUI.TabBar {
    func tabBarStyle(_ style: any TabBarStyle) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            style: style,
            dataSource: dataSource,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
    
    func itens(_ itens: [TabBarItem]) -> ItauSwiftUI.TabBar {
        dataSource._itens = itens
        return self
    }
    
    func selectedItem(_ item: TabBarItem?) -> ItauSwiftUI.TabBar {
        if let item = item {
            dataSource.selectedItem = item
        }
        return self
    }
    
    func state(_ state: TabBarState) -> ItauSwiftUI.TabBar {
        dataSource.state = state
        return self
    }
    
    func delegate(_ delegate: TabBarDelegate?) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            style: style,
            dataSource: dataSource,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
    
    func animated(_ isAnimated: Bool) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            style: style,
            dataSource: dataSource,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
    
    func show() -> ItauSwiftUI.TabBar {
        dataSource.state = TabBarState.visible
        return self
    }
    
    func hide() -> ItauSwiftUI.TabBar {
        dataSource.state = TabBarState.hidden
        return self
    }
}

// MARK: - TabBar Convenience Initializers
extension ItauSwiftUI.TabBar {
    init(
        itens: [TabBarItem] = [],
        selectedItem: TabBarItem? = nil,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true
    ) {
        self.init(
            style: DefaultTabBarStyle(),
            dataSource: MockTabBarDataSource(itens: itens, selectedItem: selectedItem),
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
}

// MARK: - TabBar View Modifier
struct TabBarModifier: ViewModifier {
    let dataSource: TabBarDataSource
    let delegate: TabBarDelegate?
    let isAnimated: Bool
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            ItauSwiftUI.TabBar(
                style: DefaultTabBarStyle(),
                dataSource: dataSource as! MockTabBarDataSource,
                delegate: delegate,
                isAnimated: isAnimated
            )
        }
    }
}

extension View {
    func tabBar(
        dataSource: TabBarDataSource,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true
    ) -> some View {
        modifier(TabBarModifier(
            dataSource: dataSource,
            delegate: delegate,
            isAnimated: isAnimated
        ))
    }
}

// MARK: - TabBar Data Source Binding
extension ItauSwiftUI.TabBar {
    func bind(to dataSource: TabBarDataSource) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            style: style,
            dataSource: dataSource as! MockTabBarDataSource,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
}

// MARK: - OnChange Compatibility Modifier
@available(macOS 11.0, iOS 14.0, *)
struct OnChangeModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let action: (Value) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            content
                .onChange(of: value) { oldValue, newValue in
                    action(newValue)
                }
        } else {
            content
                .onChange(of: value) { newValue in
                    action(newValue)
                }
        }
    }
}
