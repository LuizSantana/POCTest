import XCTest
@testable import TabBarComponent

final class TabBarComponentTests: XCTestCase {
    
    func testTabBarItemCreation() throws {
        let item = TabBarItem(
            identifier: "test",
            title: "Test",
            icon: "star.fill",
            deeplink: "app://test",
            modal: false,
            analytics: "test_analytics"
        )
        
        XCTAssertEqual(item.id, "test")
        XCTAssertEqual(item.title, "Test")
        XCTAssertEqual(item.icon, "star.fill")
        XCTAssertEqual(item.deeplink, "app://test")
        XCTAssertEqual(item.modal, false)
        XCTAssertEqual(item.analytics, "test_analytics")
    }
    
    func testTabBarState() throws {
        let visibleState = TabBarState.visible
        let hiddenState = TabBarState.hidden
        
        XCTAssertTrue(visibleState.isVisible)
        XCTAssertFalse(hiddenState.isVisible)
    }
    
    func testDataProvider() throws {
        let dataProvider = DefaultTabBarDataProvider()
        let items = TabBarItemFactory.createDefaultItems()
        
        dataProvider.updateItems(items)
        
        XCTAssertEqual(dataProvider.items.count, 4)
        XCTAssertNotNil(dataProvider.selectedItem)
        XCTAssertEqual(dataProvider.state, .visible)
    }
    
    func testTabBarItemFactory() throws {
        let defaultItems = TabBarItemFactory.createDefaultItems()
        let extendedItems = TabBarItemFactory.createExtendedItems()
        
        XCTAssertEqual(defaultItems.count, 4)
        XCTAssertEqual(extendedItems.count, 5)
        
        let homeItem = TabBarItemFactory.createHomeItem()
        XCTAssertEqual(homeItem.id, "home")
        XCTAssertEqual(homeItem.title, "Home")
        XCTAssertEqual(homeItem.icon, "house.fill")
    }
}
