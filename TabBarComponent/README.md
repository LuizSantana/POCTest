# TabBarComponent

A comprehensive, composable SwiftUI TabBar component built with the MV (Model-View) pattern, featuring dynamic content creation, mixed UIKit/SwiftUI support, and iOS 26 search functionality.

## 🚀 Features

### Core Features
- **Composable Architecture** - Built with the MV pattern for clean separation of concerns
- **Dynamic Content Creation** - Automatically detects and handles both UIKit and SwiftUI content
- **Mixed Technology Support** - Seamlessly integrates UIKit view controllers and SwiftUI views
- **OS Color Scheme Integration** - Automatically adapts to system dark/light mode
- **Multiple TabBar Styles** - Default, Compact, Floating, and Minimal styles
- **iOS 26 Search Support** - Advanced search functionality with suggestions
- **Comprehensive Testing** - UI tests using XCAutomation framework

### Advanced Features
- **Dynamic UIViewController/View Detection** - Intelligent content type resolution
- **Priority-Based Content Selection** - UIKit → Custom SwiftUI → Default SwiftUI
- **Delegate Pattern** - Flexible event handling and content creation
- **Factory Pattern** - Easy component creation and configuration
- **Environment Integration** - Respects system preferences and accessibility settings

## 📁 Project Structure

```
TabBarComponent/
├── TabBarComponent/
│   ├── TabBar Components/
│   │   ├── TabBar.swift                    # Main TabBar component
│   │   ├── TabBarModel.swift               # Data models and protocols
│   │   ├── TabBarStyle.swift               # Style system and modifiers
│   │   ├── TabBarViews.swift               # TabBar view implementations
│   │   ├── TabBarDataProvider.swift        # Data source protocols and implementations
│   │   ├── TabContentViews.swift           # SwiftUI content views
│   │   ├── UIKitTabControllers.swift       # UIKit view controllers
│   │   ├── DynamicTabBarDelegate.swift     # Dynamic delegate implementation
│   │   ├── iOS26SearchTabBar.swift         # iOS 26 search functionality
│   │   └── SwiftUITabBarRegister.swift     # UIKit integration
│   ├── Examples/
│   │   ├── TabBarExample.swift             # Basic usage examples
│   │   ├── ComponentStyleExample.swift     # Style pattern examples
│   │   └── iOS26SearchTabBarExample.swift  # Search functionality examples
│   ├── ContentView.swift                   # Main app content
│   └── TabBarComponentApp.swift            # App entry point
├── TabBarComponentUITests/
│   └── TabBarComponentUITests.swift        # UI automation tests
└── README.md                               # This file
```

## 🏗️ Architecture

### MV Pattern Implementation
- **Model**: `TabBarItem`, `TabBarState`, `TabBarAction`, `TabBarConfiguration`
- **View**: `ItauSwiftUI.TabBar`, `TabBarStyle` implementations, content views
- **No ViewModel**: Direct data binding using `@ObservedObject` and `@State`

### Core Components

#### 1. TabBar Component (`ItauSwiftUI.TabBar`)
```swift
struct TabBar: View {
    init(
        style: any TabBarStyle,
        dataSource: MockTabBarDataSource,
        delegate: TabBarDelegate? = nil,
        isAnimated: Bool = true
    )
}
```

#### 2. Data Source Protocol (`TabBarDataSource`)
```swift
protocol TabBarDataSource: AnyObject {
    func itens() -> [TabBarItem]
    func action(for tabItem: TabBarItem) -> TabBarAction?
    func controller(for tabItem: TabBarItem) -> UIViewController?
}
```

#### 3. Delegate Protocol (`TabBarDelegate`)
```swift
protocol TabBarDelegate: AnyObject {
    func tabBar(_ tabBar: any View, didSelectItem item: TabBarItem)
    func tabBar(_ tabBar: any View, didPerformAction action: TabBarAction, for item: TabBarItem)
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController?
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView?
}
```

## 🎨 TabBar Styles

### Available Styles
1. **Default** - Standard iOS tab bar with separator
2. **Compact** - Minimal design with rounded selection
3. **Floating** - Floating design with material background
4. **Minimal** - Ultra-minimal design with clear background

### Style Usage
```swift
// Basic usage
ItauSwiftUI.TabBar(
    style: DefaultTabBarStyle(),
    dataSource: dataSource
)

// With modifiers
ItauSwiftUI.TabBar(
    style: DefaultTabBarStyle()
        .background(.blue, cornerRadius: 12)
        .shadow(radius: 8)
        .padding(horizontal: 16, vertical: 8),
    dataSource: dataSource
)
```

## 🔍 Dynamic Content Creation

### Content Type Detection
The TabBar automatically detects and handles different content types:

1. **UIKit View Controllers** - Returns `UIViewController` from delegate
2. **Custom SwiftUI Views** - Returns `AnyView` from delegate
3. **Default SwiftUI Views** - Fallback based on deeplink

### Implementation Example
```swift
class DynamicTabBarDelegate: TabBarDelegate {
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController? {
        switch item.identifier {
        case "home":
            return HomeUIKitViewController(item: item)
        case "profile":
            return ProfileUIKitViewController(item: item)
        default:
            return nil // Use SwiftUI fallback
        }
    }
    
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView? {
        switch item.deeplink {
        case "app://favorites":
            return AnyView(CustomFavoritesView(item: item))
        case "app://settings":
            return AnyView(CustomSettingsView(item: item))
        default:
            return nil // Use default fallback
        }
    }
}
```

## 🔍 iOS 26 Search Functionality

### Search Features
- **Real-time Search** - Search as you type with suggestions
- **Smart Suggestions** - Auto-generated from tab items
- **Multiple Styles** - Default, Compact, Expanded, Floating
- **Deep Linking** - Search queries integrated with navigation

### Search Usage
```swift
let searchConfig = iOS26SearchTabBarConfiguration(
    searchPlaceholder: "Search tabs...",
    searchEnabled: true,
    searchStyle: .floating
)

iOS26SearchTabBar(
    configuration: searchConfig,
    dataSource: dataSource,
    delegate: delegate
)
```

### Search Styles
```swift
enum SearchTabBarStyle: String, CaseIterable {
    case `default` = "default"    // Standard iOS search bar
    case compact = "compact"      // Minimal search interface
    case expanded = "expanded"    // Enhanced search with borders
    case floating = "floating"    // Floating search with shadow
}
```

## 🎯 Data Models

### TabBarItem
```swift
struct TabBarItem: Identifiable, Equatable, Hashable {
    let id: String
    let identifier: String
    let title: String?
    let icon: String
    let deeplink: String
    let modal: Bool?
    let analytics: String
}
```

### TabBarState
```swift
enum TabBarState {
    case visible
    case hidden
    
    var isVisible: Bool {
        self == .visible
    }
}
```

### TabBarAction
```swift
enum TabBarAction {
    case resetNavigationStack
    case present
    case push
}
```

## 🛠️ Usage Examples

### Basic Implementation
```swift
struct ContentView: View {
    @State private var dataSource = MockTabBarDataSource(
        itens: TabBarItemFactory.createDefaultItens()
    )
    
    var body: some View {
        ItauSwiftUI.TabBar(
            style: DefaultTabBarStyle(),
            dataSource: dataSource,
            delegate: SampleTabBarDelegate()
        )
    }
}
```

### Custom Style with Modifiers
```swift
ItauSwiftUI.TabBar(
    style: FloatingTabBarStyle()
        .background(.ultraThinMaterial, cornerRadius: 20)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(horizontal: 20, vertical: 12),
    dataSource: dataSource
)
```

### Dynamic Content with Mixed Technologies
```swift
class MixedContentDelegate: TabBarDelegate {
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController? {
        // Return UIKit controllers for specific tabs
        switch item.identifier {
        case "home", "profile":
            return UIKitViewController(item: item)
        default:
            return nil
        }
    }
    
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView? {
        // Return custom SwiftUI views for other tabs
        switch item.deeplink {
        case "app://favorites":
            return AnyView(CustomFavoritesView(item: item))
        default:
            return nil
        }
    }
}
```

## 🧪 Testing

### UI Tests
The project includes comprehensive UI tests using XCAutomation:

```swift
func testTabBarVisibility() {
    let app = XCUIApplication()
    app.launch()
    
    let tabBar = app.otherElements["TabBar"]
    XCTAssertTrue(tabBar.exists)
    
    let toggleButton = app.buttons["Toggle TabBar"]
    toggleButton.tap()
    
    XCTAssertFalse(tabBar.exists)
}
```

### Test Coverage
- TabBar visibility/hiding
- Style switching
- Item selection
- Dark mode adaptation
- Search functionality (iOS 26)

## 🔧 Configuration

### Environment Variables
- **Color Scheme** - Automatically follows system dark/light mode
- **Size Classes** - Adapts to compact/regular horizontal size classes
- **Accessibility** - Respects accessibility preferences

### Customization Options
- **TabBar Styles** - 4 built-in styles with modifier support
- **Content Types** - UIKit, SwiftUI, or mixed content
- **Search Configuration** - Customizable search behavior
- **Animation** - Configurable animations and transitions

## 📱 iOS Compatibility

- **Minimum iOS Version**: 15.6
- **iOS 26 Features**: Search functionality with `@available(iOS 26.0, *)`
- **Backward Compatibility**: Graceful degradation for older iOS versions
- **SwiftUI Version**: 5.0+

## 🚀 Getting Started

### 1. Installation
Add the TabBarComponent files to your Xcode project.

### 2. Basic Setup
```swift
import SwiftUI

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 3. Create Data Source
```swift
let dataSource = MockTabBarDataSource(
    itens: TabBarItemFactory.createDefaultItens()
)
```

### 4. Add TabBar
```swift
ItauSwiftUI.TabBar(
    style: DefaultTabBarStyle(),
    dataSource: dataSource
)
```

## 🔄 Migration Guide

### From Previous Versions
1. **Remove darkMode/lightMode** - Now uses OS color scheme
2. **Update delegate methods** - New signature with `any View`
3. **Use new naming** - `itens` instead of `items`, `TabBarDataSource` instead of `TabBarDataProvider`

### Breaking Changes
- `TabBarDataProvider` → `TabBarDataSource`
- `items()` → `itens()`
- Removed manual dark mode management
- Updated delegate method signatures

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with SwiftUI and UIKit
- Follows Apple Human Interface Guidelines
- Implements modern iOS design patterns
- Supports accessibility best practices

## 📞 Support

For questions, issues, or contributions, please:
1. Check the existing issues
2. Create a new issue with detailed information
3. Follow the contribution guidelines

---

**TabBarComponent** - A modern, composable SwiftUI TabBar solution for iOS applications.
