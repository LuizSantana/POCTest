# SwiftUI TabBar Component

A native SwiftUI TabBar component built on top of TabView with composable styles, following MV pattern architecture without ViewModel.

## Features

- ✅ **TabView-based**: Built on native SwiftUI TabView for optimal performance
- ✅ **Composable Styles**: Inspired by SwiftUI's style system with composable modifiers
- ✅ **MV Pattern**: Model-View architecture without ViewModel dependency
- ✅ **Show/Hide**: Dynamic visibility control with smooth animations
- ✅ **Data Provider**: Flexible data management with ObservableObject
- ✅ **Multiple Styles**: Default, Compact, Floating, and Minimal styles
- ✅ **Customizable**: Easy to extend with custom styles and modifiers

## Architecture

### Model-View Pattern
- **Model**: `TabBarItem`, `TabBarState`, `TabBarConfiguration`
- **View**: `TabBar`, `TabBarStyle`, `TabBarViews`
- **Data Provider**: `TabBarDataProvider` for state management

### Key Components

1. **TabBarItem**: Represents a tab item with identifier, title, icon, deeplink, modal flag, and analytics
2. **TabBarStyle**: Protocol for creating custom tab bar styles
3. **TabBarDataProvider**: ObservableObject for managing tab bar state
4. **TabBar**: Main component that wraps TabView with custom styling

## Usage

### Basic Usage

```swift
TabBar(
    items: TabBarItemFactory.createDefaultItems(),
    onItemSelected: { item in
        print("Selected: \(item.title ?? item.id)")
    }
) { item in
    // Content for each tab
    TabContentView(item: item)
}
```

### With Custom Style

```swift
TabBar(
    style: .floating
        .background(Color.blue.opacity(0.1), cornerRadius: 20)
        .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6),
    items: TabBarItemFactory.createDefaultItems()
) { item in
    TabContentView(item: item)
}
```

### With Data Provider

```swift
@StateObject private var dataProvider = DefaultTabBarDataProvider()

TabBar(
    dataProvider: dataProvider,
    items: TabBarItemFactory.createDefaultItems()
) { item in
    TabContentView(item: item)
}

// Control visibility
Button("Hide TabBar") {
    dataProvider.setState(.hidden)
}
```

## Available Styles

### Default Style
```swift
TabBar(style: .default, items: items) { item in
    // Content
}
```

### Compact Style
```swift
TabBar(style: .compact, items: items) { item in
    // Content
}
```

### Floating Style
```swift
TabBar(style: .floating, items: items) { item in
    // Content
}
```

### Minimal Style
```swift
TabBar(style: .minimal, items: items) { item in
    // Content
}
```

## Composable Modifiers

The TabBar supports composable style modifiers inspired by SwiftUI's style system:

```swift
TabBar(
    style: .default
        .background(Color.blue.opacity(0.1), cornerRadius: 20)
        .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
        .padding(horizontal: 20, vertical: 12)
        .animation(.spring(response: 0.5, dampingFraction: 0.8)),
    items: items
) { item in
    // Content
}
```

### Available Modifiers

- `.background(_:cornerRadius:)` - Set background color and corner radius
- `.shadow(color:radius:x:y:)` - Add shadow effect
- `.padding(horizontal:vertical:)` - Set padding
- `.animation(_:)` - Set animation for state changes

## TabBarItem Model

```swift
struct TabBarItem: Identifiable, Equatable, Hashable {
    let id: String              // Unique identifier
    let title: String?          // Optional title text
    let icon: String           // SF Symbol name
    let deeplink: String       // Navigation deeplink
    let modal: Bool?           // Whether to present as modal
    let analytics: String      // Analytics tracking string
}
```

## Data Provider

The `TabBarDataProvider` protocol provides a clean interface for managing tab bar state:

```swift
protocol TabBarDataProvider: ObservableObject {
    var items: [TabBarItem] { get }
    var selectedItem: TabBarItem? { get }
    var state: TabBarState { get }
    
    func selectItem(_ item: TabBarItem)
    func setState(_ state: TabBarState)
    func updateItems(_ items: [TabBarItem])
}
```

## Show/Hide Functionality

Control tab bar visibility with smooth animations:

```swift
// Show tab bar
dataProvider.setState(.visible)

// Hide tab bar
dataProvider.setState(.hidden)

// Or use convenience methods
tabBar.show()
tabBar.hide()
```

## Custom Styles

Create custom tab bar styles by conforming to `TabBarStyle`:

```swift
struct CustomTabBarStyle: TabBarStyle {
    func makeBody(configuration: TabBarStyleConfiguration) -> some View {
        // Your custom implementation
        CustomTabBarView(configuration: configuration)
    }
}

// Use it
TabBar(style: CustomTabBarStyle(), items: items) { item in
    // Content
}
```

## Examples

See `TabBarExample.swift` for comprehensive usage examples including:

- Basic tab bar implementation
- Multiple style demonstrations
- Composable style examples
- Data provider integration
- Show/hide functionality

## Requirements

- iOS 14.0+
- SwiftUI
- Xcode 12.0+

## Installation

Simply copy the TabBar files to your project:

- `TabBarModel.swift`
- `TabBarStyle.swift`
- `TabBarDataProvider.swift`
- `TabBarViews.swift`
- `TabBar.swift`
- `TabBarExample.swift` (for examples)

## Design Principles

This implementation follows the design principles from the referenced articles:

1. **Composable Styles**: Inspired by [Composable Styles in SwiftUI](https://movingparts.io/composable-styles-in-swiftui)
2. **Scalable Design System**: Following [Crafting SwiftUI Components](https://www.designsystemscollective.com/crafting-swiftui-components-for-a-scalable-design-system-51e88fed81f5)
3. **MV Pattern**: Clean separation of concerns without ViewModel complexity
4. **Native Performance**: Built on TabView for optimal SwiftUI performance

## License

This component is provided as-is for educational and development purposes.
