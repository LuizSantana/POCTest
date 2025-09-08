import SwiftUI

// MARK: - TabBar Style Protocol
protocol TabBarStyle {
    associatedtype Body: View
    func makeBody(configuration: TabBarStyleConfiguration) -> Body
}

// MARK: - TabBar Style Configuration
struct TabBarStyleConfiguration {
    let items: [TabBarItem]
    let selectedItem: TabBarItem?
    let onItemSelected: (TabBarItem) -> Void
    let state: TabBarState
}

// MARK: - Default TabBar Style
struct DefaultTabBarStyle: TabBarStyle {
    func makeBody(configuration: TabBarStyleConfiguration) -> some View {
        DefaultTabBarView(configuration: configuration)
    }
}

// MARK: - Compact TabBar Style
struct CompactTabBarStyle: TabBarStyle {
    func makeBody(configuration: TabBarStyleConfiguration) -> some View {
        CompactTabBarView(configuration: configuration)
    }
}

// MARK: - Floating TabBar Style
struct FloatingTabBarStyle: TabBarStyle {
    func makeBody(configuration: TabBarStyleConfiguration) -> some View {
        FloatingTabBarView(configuration: configuration)
    }
}

// MARK: - Minimal TabBar Style
struct MinimalTabBarStyle: TabBarStyle {
    func makeBody(configuration: TabBarStyleConfiguration) -> some View {
        MinimalTabBarView(configuration: configuration)
    }
}

// MARK: - TabBar Style Extensions
extension TabBarStyle where Self == DefaultTabBarStyle {
    static var `default`: DefaultTabBarStyle { DefaultTabBarStyle() }
}

extension TabBarStyle where Self == CompactTabBarStyle {
    static var compact: CompactTabBarStyle { CompactTabBarStyle() }
}

extension TabBarStyle where Self == FloatingTabBarStyle {
    static var floating: FloatingTabBarStyle { FloatingTabBarStyle() }
}

extension TabBarStyle where Self == MinimalTabBarStyle {
    static var minimal: MinimalTabBarStyle { MinimalTabBarStyle() }
}

// MARK: - Composable Style Support
struct ModifiedTabBarStyle<Style: TabBarStyle, Modifier: ViewModifier>: TabBarStyle {
    var style: Style
    var modifier: Modifier
    
    func makeBody(configuration: TabBarStyleConfiguration) -> some View {
        style.makeBody(configuration: configuration)
            .modifier(modifier)
    }
}

extension TabBarStyle {
    func modifier(_ modifier: some ViewModifier) -> some TabBarStyle {
        ModifiedTabBarStyle(style: self, modifier: modifier)
    }
}

// MARK: - TabBar Style Modifiers
struct TabBarBackgroundModifier: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
    }
}

struct TabBarShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}

struct TabBarPaddingModifier: ViewModifier {
    let horizontal: CGFloat
    let vertical: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontal)
            .padding(.vertical, vertical)
    }
}

struct TabBarAnimationModifier: ViewModifier {
    let animation: Animation
    
    func body(content: Content) -> some View {
        content
            .animation(animation, value: UUID())
    }
}

// MARK: - TabBar Style Convenience Extensions
extension TabBarStyle {
    func background(_ color: Color, cornerRadius: CGFloat = 0) -> some TabBarStyle {
        modifier(TabBarBackgroundModifier(backgroundColor: color, cornerRadius: cornerRadius))
    }
    
    func shadow(color: Color = .black.opacity(0.1), radius: CGFloat = 8, x: CGFloat = 0, y: CGFloat = 4) -> some TabBarStyle {
        modifier(TabBarShadowModifier(color: color, radius: radius, x: x, y: y))
    }
    
    func padding(horizontal: CGFloat = 16, vertical: CGFloat = 8) -> some TabBarStyle {
        modifier(TabBarPaddingModifier(horizontal: horizontal, vertical: vertical))
    }
    
    func animation(_ animation: Animation = .easeInOut(duration: 0.3)) -> some TabBarStyle {
        modifier(TabBarAnimationModifier(animation: animation))
    }
}

// MARK: - TabBar Environment Support
struct TabBarStyleKey: EnvironmentKey {
    static let defaultValue: any TabBarStyle = DefaultTabBarStyle()
}

extension EnvironmentValues {
    var tabBarStyle: any TabBarStyle {
        get { self[TabBarStyleKey.self] }
        set { self[TabBarStyleKey.self] = newValue }
    }
}

extension View {
    func tabBarStyle(_ style: any TabBarStyle) -> some View {
        environment(\.tabBarStyle, style)
    }
}