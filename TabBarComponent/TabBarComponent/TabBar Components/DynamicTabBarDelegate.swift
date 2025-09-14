import Foundation
import SwiftUI
import UIKit

// MARK: - Dynamic TabBar Delegate Example
class DynamicTabBarDelegate: TabBarDelegate, ObservableObject {
    
    // MARK: - TabBarDelegate Methods
    func tabBar(_ tabBar: any View, didSelectItem item: TabBarItem) {
        print("Dynamic TabBar delegate: Selected item \(item.title ?? item.id)")
    }
    
    func tabBar(_ tabBar: any View, didPerformAction action: TabBarAction, for item: TabBarItem) {
        print("Dynamic TabBar delegate: Performed action \(action) for item \(item.title ?? item.id)")
    }
    
    // MARK: - Dynamic Controller/View Selection
    func tabBar(_ tabBar: any View, controllerFor item: TabBarItem) -> UIViewController? {
        // Return UIKit controllers for specific tabs based on identifier
        switch item.identifier {
        case "home":
            return HomeUIKitViewController(item: item)
        case "profile":
            return ProfileUIKitViewController(item: item)
        default:
            return nil // Let the system try createContentViewFor instead
        }
    }
    
    func tabBar(_ tabBar: any View, createContentViewFor item: TabBarItem) -> AnyView? {
        // Return custom SwiftUI views for specific tabs
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

// MARK: - Custom SwiftUI Views
struct CustomFavoritesView: View {
    let item: TabBarItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Custom header
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.red)
                    
                    Text("Custom Favorites (SwiftUI)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("This is a custom SwiftUI view created by the delegate")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Custom favorites grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(0..<6, id: \.self) { index in
                        CustomFavoriteCard(
                            title: "Custom Favorite \(index + 1)",
                            subtitle: "Delegate-created view",
                            icon: "star.fill"
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Custom Favorites")
    }
}

struct CustomSettingsView: View {
    let item: TabBarItem
    
    var body: some View {
        List {
            Section("Custom Settings") {
                CustomSettingsRow(
                    icon: "gear",
                    title: "Custom Option 1",
                    value: "Enabled"
                )
                
                CustomSettingsRow(
                    icon: "bell",
                    title: "Custom Option 2",
                    value: "Disabled"
                )
                
                CustomSettingsRow(
                    icon: "lock",
                    title: "Custom Option 3",
                    value: ""
                )
            }
            
            Section("Delegate Information") {
                CustomSettingsRow(
                    icon: "info.circle",
                    title: "View Type",
                    value: "SwiftUI (Delegate)"
                )
                
                CustomSettingsRow(
                    icon: "arrow.triangle.branch",
                    title: "Creation Method",
                    value: "createContentViewFor"
                )
            }
        }
        .navigationTitle("Custom Settings")
    }
}

// MARK: - Supporting Views
struct CustomFavoriteCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.red)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

struct CustomSettingsRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
