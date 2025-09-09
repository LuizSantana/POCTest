import SwiftUI

// MARK: - TabBar Component (TabView-based)
struct TabBar<Content: View>: View {
    @StateObject private var dataProvider: DefaultTabBarDataProvider
    private let style: any TabBarStyle
    private let delegate: TabBarDelegate?
    private let isAnimated: Bool
    
    private let content: (TabBarItem) -> Content
    
    init(
        style: any TabBarStyle,
        dataProvider: DefaultTabBarDataProvider,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true,
        @ViewBuilder content: @escaping (TabBarItem) -> Content
    ) {
        self.style = style
        self.delegate = delegate
        self.isAnimated = isAnimated
        self.content = content
        
        // Set delegate on data provider before creating StateObject
        dataProvider.delegate = delegate
        self._dataProvider = StateObject(wrappedValue: dataProvider)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $dataProvider.selectedItem) {
                ForEach(dataProvider.items) { item in
                    content(item)
                        .tabItem {
                            TabBarItemLabel(item: item)
                        }
                        .tag(item)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom TabBar styling overlay
            AnyView(style.makeBody(configuration: configuration))
                .opacity(dataProvider.state.isVisible ? 1 : 0)
                .animation(isAnimated ? .easeInOut(duration: 0.3) : nil, value: dataProvider.state)
        }
        .modifier(OnChangeModifier(
            value: dataProvider.selectedItem,
            action: { newValue in
                if let newValue = newValue {
                    delegate?.tabBar(TabBar<AnyView>(), didSelectItem: newValue)
                }
            }
        ))
    }
    
    private var configuration: TabBarStyleConfiguration {
        TabBarStyleConfiguration(
            items: dataProvider.items,
            selectedItem: dataProvider.selectedItem,
            onItemSelected: { item in
                dataProvider.selectItem(item)
            },
            state: dataProvider.state
        )
    }
}

// MARK: - TabBar Item Label
struct TabBarItemLabel: View {
    let item: TabBarItem
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: item.icon)
                .font(.system(size: 16, weight: .medium))
            
            if let title = item.title {
                Text(title)
                    .font(.caption2)
            }
        }
    }
}


// MARK: - TabBar Modifiers
extension TabBar {
    func tabBarStyle(_ style: any TabBarStyle) -> TabBar<Content> {
        TabBar<Content>(
            style: style,
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated,
            content: content
        )
    }
    
    func items(_ items: [TabBarItem]) -> TabBar<Content> {
        dataProvider.updateItems(items)
        return self
    }
    
    func selectedItem(_ item: TabBarItem?) -> TabBar<Content> {
        if let item = item {
            dataProvider.selectItem(item)
        }
        return self
    }
    
    func state(_ state: TabBarState) -> TabBar<Content> {
        dataProvider.setState(state)
        return self
    }
    
    func delegate(_ delegate: TabBarDelegate?) -> TabBar<Content> {
        TabBar<Content>(
            style: style,
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated,
            content: content
        )
    }
    
    func animated(_ isAnimated: Bool) -> TabBar<Content> {
        TabBar<Content>(
            style: style,
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated,
            content: content
        )
    }
    
    func show() -> TabBar<Content> {
        dataProvider.setState(.visible)
        return self
    }
    
    func hide() -> TabBar<Content> {
        dataProvider.setState(.hidden)
        return self
    }
}

// MARK: - TabBar Convenience Initializers
extension TabBar {
    init(
        items: [TabBarItem] = [],
        selectedItem: TabBarItem? = nil,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true,
        @ViewBuilder content: @escaping (TabBarItem) -> Content
    ) {
        self.init(
            style: DefaultTabBarStyle(),
            dataProvider: DefaultTabBarDataProvider(items: items, selectedItem: selectedItem),
            delegate: delegate,
            isAnimated: isAnimated,
            content: content
        )
    }
}


// MARK: - TabBar View Modifier
struct TabBarModifier<TabContent: View>: ViewModifier {
    let items: [TabBarItem]
    let selectedItem: TabBarItem?
    let state: TabBarState
    let delegate: TabBarDelegate?
    let isAnimated: Bool
    let tabContent: (TabBarItem) -> TabContent
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            TabBar(
                style: DefaultTabBarStyle(),
                dataProvider: DefaultTabBarDataProvider(items: items, selectedItem: selectedItem),
                delegate: delegate,
                isAnimated: isAnimated,
                content: tabContent
            )
        }
    }
}

extension View {
    func tabBar<TabContent: View>(
        items: [TabBarItem],
        selectedItem: TabBarItem? = nil,
        state: TabBarState = .visible,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true,
        @ViewBuilder content: @escaping (TabBarItem) -> TabContent
    ) -> some View {
        modifier(TabBarModifier(
            items: items,
            selectedItem: selectedItem,
            state: state,
            delegate: delegate,
            isAnimated: isAnimated,
            tabContent: content
        ))
    }
}

// MARK: - TabBar Data Provider Binding
extension TabBar {
    func bind(to dataProvider: DefaultTabBarDataProvider) -> TabBar<Content> {
        TabBar<Content>(
            style: style,
            dataProvider: dataProvider,
            delegate: delegate,
            isAnimated: isAnimated,
            content: content
        )
    }
}

// MARK: - OnChange Compatibility Modifier
struct OnChangeModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let action: (Value) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
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