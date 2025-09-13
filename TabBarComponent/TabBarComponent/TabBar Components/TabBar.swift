import SwiftUI

// MARK: - ItauSwiftUI Namespace
struct ItauSwiftUI {
    // MARK: - TabBar Component (TabView-based)
    struct TabBar: View {
        private let dataProvider: MockTabBarDataProvider
        private let style: any TabBarStyle
        private let delegate: TabBarDelegate?
        private let isAnimated: Bool
        
        @State private var selectedItem: TabBarItem?
        
        init(
            style: any TabBarStyle,
            dataProvider: MockTabBarDataProvider,
            delegate: TabBarDelegate? = nil,
            isAnimated: Bool = true
        ) {
            self.style = style
            self.dataProvider = dataProvider
            self.delegate = delegate
            self.isAnimated = isAnimated
            self._selectedItem = State(initialValue: dataProvider.items().first)
        }
        
        var body: some View {
            VStack(spacing: 0) {
                TabView(selection: $selectedItem) {
                    ForEach(dataProvider.items()) { item in
                        TabContentView(item: item)
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
                items: dataProvider.items(),
                selectedItem: selectedItem,
                onItemSelected: { item in
                    selectedItem = item
                },
                state: .visible
            )
        }
    }
    
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
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
    
    func items(_ items: [TabBarItem]) -> ItauSwiftUI.TabBar {
        dataProvider.updateItems(items)
        return self
    }
    
    func selectedItem(_ item: TabBarItem?) -> ItauSwiftUI.TabBar {
        if let item = item {
            dataProvider.selectItem(item)
        }
        return self
    }
    
    func state(_ state: TabBarState) -> ItauSwiftUI.TabBar {
        dataProvider.setState(state)
        return self
    }
    
    func delegate(_ delegate: TabBarDelegate?) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            style: style,
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
    
    func animated(_ isAnimated: Bool) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            style: style,
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
    
    func show() -> ItauSwiftUI.TabBar {
        dataProvider.setState(TabBarState.visible)
        return self
    }
    
    func hide() -> ItauSwiftUI.TabBar {
        dataProvider.setState(TabBarState.hidden)
        return self
    }
}

// MARK: - TabBar Convenience Initializers
extension ItauSwiftUI.TabBar {
    init(
        items: [TabBarItem] = [],
        selectedItem: TabBarItem? = nil,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true
    ) {
        self.init(
            style: DefaultTabBarStyle(),
            dataProvider: MockTabBarDataProvider(items: items, selectedItem: selectedItem),
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
}

// MARK: - TabBar View Modifier
struct TabBarModifier: ViewModifier {
    let dataProvider: TabBarDataProvider
    let delegate: TabBarDelegate?
    let isAnimated: Bool
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            ItauSwiftUI.TabBar(
                style: DefaultTabBarStyle(),
                dataProvider: dataProvider as! MockTabBarDataProvider,
                delegate: delegate,
                isAnimated: isAnimated
            )
        }
    }
}

extension View {
    func tabBar(
        dataProvider: TabBarDataProvider,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true
    ) -> some View {
        modifier(TabBarModifier(
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated
        ))
    }
}

// MARK: - TabBar Data Provider Binding
extension ItauSwiftUI.TabBar {
    func bind(to dataProvider: TabBarDataProvider) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            style: style,
            dataProvider: dataProvider as! MockTabBarDataProvider,
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
