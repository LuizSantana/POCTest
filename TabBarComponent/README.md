# TabBarComponent

A modern, native SwiftUI TabBar component built with the MV (Model-View) pattern, featuring dynamic content creation, mixed UIKit/SwiftUI support, IDSDesignSystem integration, and iOS 26 search functionality.

## 🚀 Features

### Core Features
- **Native SwiftUI TabView** - Uses iOS 18+ Tab view with backward compatibility
- **IDSDesignSystem Integration** - Consistent theming and icon management
- **Dynamic Content Creation** - Automatically detects and handles both UIKit and SwiftUI content
- **Mixed Technology Support** - Seamlessly integrates UIKit view controllers and SwiftUI views
- **Environment-Based Theming** - Uses `@Environment(\.self)` for dynamic color theming
- **iOS 26 Search Support** - Advanced search functionality with suggestions
- **Comprehensive Testing** - UI tests using XCAutomation framework

### Advanced Features
- **Dynamic UIViewController/View Detection** - Intelligent content type resolution
- **Priority-Based Content Selection** - UIKit → Custom SwiftUI → Default SwiftUI
- **Delegate Pattern** - Flexible event handling and content creation
- **Factory Pattern** - Easy component creation and configuration
- **Environment Integration** - Respects system preferences and accessibility settings
- **iOS 18+ Compatibility** - Modern Tab view implementation with fallback support

## 📁 Project Structure

```
TabBarComponent/
├── TabBarComponent/
│   ├── TabBar Components/
│   │   ├── TabBar.swift                    # Main TabBar component (Native TabView)
│   │   ├── TabBarModel.swift               # Data models and protocols
│   │   ├── TabBarDataProvider.swift        # Data source protocols and implementations
│   │   ├── TabContentViews.swift           # SwiftUI content views
│   │   ├── UIKitTabControllers.swift       # UIKit view controllers
│   │   ├── DynamicTabBarDelegate.swift     # Dynamic delegate implementation
│   │   ├── iOS26SearchTabBar.swift         # iOS 26 search functionality
│   │   └── SwiftUITabBarRegister.swift     # UIKit integration
│   ├── Examples/
│   │   ├── TabBarExample.swift             # Basic usage examples
│   │   ├── ComponentStyleExample.swift     # Simplified examples
│   │   └── iOS26SearchTabBarExample.swift  # Search functionality examples
│   ├── ContentView.swift                   # Main app content
│   └── TabBarComponentApp.swift            # App entry point
├── TabBarComponentUITests/
│   └── TabBarComponentUITests.swift        # UI automation tests
└── README.md                               # This file
```

## 🏗️ Architecture

### MV Pattern Implementation
- **Model**: `TabBarItem`, `TabBarState`, `TabBarAction`
- **View**: `ItauSwiftUI.TabBar` (Native TabView), content views
- **No ViewModel**: Direct data binding using `@ObservedObject` and `@State`

### Core Components

#### 1. TabBar Component (`ItauSwiftUI.TabBar`)
```swift
struct TabBar: View {
    init(
        dataSource: TabBarDataSource?,
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

## 🎨 Native TabView Implementation

### iOS 18+ Tab View
The TabBar now uses the native SwiftUI TabView with iOS 18+ Tab support:

```swift
// iOS 18+ Implementation
@available(iOS 18.0, macOS 15.0, *)
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
```

### Backward Compatibility
For iOS 17 and earlier, it falls back to the traditional `.tabItem` approach:

```swift
// iOS 17 and earlier fallback
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
- **Native Styling** - Uses system default styling for consistency
- **Deep Linking** - Search queries integrated with navigation

### Search Usage
```swift
let searchConfig = iOS26SearchTabBarConfiguration(
    searchPlaceholder: "Search tabs...",
    searchEnabled: true
)

iOS26SearchTabBar(
    configuration: searchConfig,
    dataSource: dataSource,
    delegate: delegate
)
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
            dataSource: dataSource,
            delegate: SampleTabBarDelegate()
        )
    }
}
```

### With IDSDesignSystem Integration
```swift
struct TabBarItemLabel: View {
    let item: TabBarItem
    @Environment(\.self) private var themeColor
    
    var body: some View {
        VStack(spacing: 4) {
            Image(idsIcon: IDSIconResource(name: LigaduraMapper.mapLigadura(item.icon)))
                .font(.system(size: 20))
            
            if let title = item.title {
                Text(title)
                    .font(.caption2)
            }
        }
    }
}
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
- Item selection
- Dark mode adaptation
- Search functionality (iOS 26)
- IDSDesignSystem integration

## 🔧 Configuration

### Environment Variables
- **Color Scheme** - Uses `@Environment(\.self)` for dynamic theming
- **Size Classes** - Adapts to compact/regular horizontal size classes
- **Accessibility** - Respects accessibility preferences
- **IDSDesignSystem** - Integrated theming and icon management

### Customization Options
- **Native Styling** - Uses system default TabView styling
- **Content Types** - UIKit, SwiftUI, or mixed content
- **Search Configuration** - Customizable search behavior
- **Animation** - Configurable animations and transitions
- **Icon Management** - IDSDesignSystem with LigaduraMapper integration

## 📱 iOS Compatibility

- **Minimum iOS Version**: 15.6
- **iOS 18+ Features**: Native Tab view with `@available(iOS 18.0, macOS 15.0, *)`
- **iOS 26 Features**: Search functionality with `@available(iOS 26.0, *)`
- **Backward Compatibility**: Graceful degradation for older iOS versions
- **SwiftUI Version**: 5.0+
- **IDSDesignSystem**: Integrated for consistent theming and icons

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
    dataSource: dataSource
)
```

## 🔄 Migration Guide

### From Previous Versions
1. **Remove style parameters** - Now uses native TabView styling
2. **Update delegate methods** - New signature with `any View`
3. **Use new naming** - `itens` instead of `items`, `TabBarDataSource` instead of `TabBarDataProvider`
4. **Add IDSDesignSystem** - Import and use for icons and theming

### Breaking Changes
- `TabBarDataProvider` → `TabBarDataSource`
- `items()` → `itens()`
- Removed all style-related parameters and enums
- Removed `TabBarStyle` protocol and implementations
- Updated to use `@Environment(\.self)` for theming
- Added IDSDesignSystem integration for icons

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
- Integrated with IDSDesignSystem for consistent theming
- Uses native iOS 18+ Tab view for optimal performance

## 📞 Support

For questions, issues, or contributions, please:
1. Check the existing issues
2. Create a new issue with detailed information
3. Follow the contribution guidelines

---

**TabBarComponent** - A modern, native SwiftUI TabBar solution with IDSDesignSystem integration for iOS applications.

