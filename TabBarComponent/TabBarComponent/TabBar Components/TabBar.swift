import SwiftUI
import IDSDesignSystem

// MARK: - ItauSwiftUI Namespace
struct ItauSwiftUI {
    // MARK: - TabBar Component (TabView-based)
    struct TabBar: View {
        private let dataSource: TabBarDataSource?
        private let delegate: TabBarDelegate?
        private let isAnimated: Bool
        
        @State private var selectedItem: TabBarItem?
        @Environment(\.self) private var themeColor
        
        init(
            dataSource: TabBarDataSource?,
            delegate: TabBarDelegate? = nil,
            isAnimated: Bool = true
        ) {
            self.dataSource = dataSource
            self.delegate = delegate
            self.isAnimated = isAnimated
            self._selectedItem = State(initialValue: dataSource?.itens().first)
        }
        
        var body: some View {
            if let dataSource = dataSource {
                if #available(iOS 18.0, macOS 15.0, *) {
                    TabView(selection: $selectedItem) {
                        ForEach(dataSource.itens()) { item in
                            Tab {
                                createContentView(for: item)
                            } label: {
                                TabBarItemLabel(item: item)
                            }
                            .tag(item)
                        }
                    }
                    .modifier(OnChangeModifier(
                        value: selectedItem,
                        action: { newValue in
                            if let newValue = newValue {
                                delegate?.tabBar(self, didSelectItem: newValue)
                            }
                        }
                    ))
                } else {
                    // Fallback for iOS 17 and earlier
                    TabView(selection: $selectedItem) {
                        ForEach(dataSource.itens()) { item in
                            createContentView(for: item)
                                .tabItem {
                                    VStack(spacing: 4) {
                                        Image(idsIcon: IDSIconResource(name: LigaduraMapper.mapLigadura(item.icon)))
                                            .font(.system(size: 20))
                                        
                                        if let title = item.title {
                                            Text(title)
                                                .font(.caption2)
                                        }
                                    }
                                }
                                .tag(item)
                        }
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
            } else {
                // Empty state when no data source
                EmptyView()
            }
        }
        
        
        // MARK: - Dynamic Content Creation
        @ViewBuilder
        private func createContentView(for item: TabBarItem) -> some View {
            // First try to get a UIViewController from data source
            if let viewController = dataSource?.controller(for: item) {
                // Use UIKit view controller from data source
                UIViewControllerWrapper(viewController: viewController)
            } else if let viewController = delegate?.tabBar(self, controllerFor: item) {
                // Use UIKit view controller from delegate
                UIViewControllerWrapper(viewController: viewController)
            } else if let customView = dataSource?.view(for: item) {
                // Try to get a custom View from data source
                customView
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
    // MARK: - TabBar Item Label (iOS 18+)
    @available(iOS 18.0, macOS 15.0, *)
    struct TabBarItemLabel: View {
        let item: TabBarItem
        @Environment(\.self) private var themeColor
        
        var body: some View {
            Tab {
                Image(idsIcon: IDSIconResource(name: LigaduraMapper.mapLigadura(item.icon)))
                    .font(.system(size: 20))
                
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
    func delegate(_ delegate: TabBarDelegate?) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            dataSource: dataSource,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
    
    func animated(_ isAnimated: Bool) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            dataSource: dataSource,
            delegate: delegate,
            isAnimated: isAnimated
        )
    }
}


// MARK: - TabBar View Modifier
struct TabBarModifier: ViewModifier {
    let dataSource: TabBarDataSource?
    let delegate: TabBarDelegate?
    let isAnimated: Bool
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            ItauSwiftUI.TabBar(
                dataSource: dataSource,
                delegate: delegate,
                isAnimated: isAnimated
            )
        }
    }
}

extension View {
    func tabBar(
        dataSource: TabBarDataSource?,
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
    func bind(to dataSource: TabBarDataSource?) -> ItauSwiftUI.TabBar {
        ItauSwiftUI.TabBar(
            dataSource: dataSource,
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
