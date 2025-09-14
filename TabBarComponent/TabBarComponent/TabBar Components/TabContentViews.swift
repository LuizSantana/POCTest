import Foundation
import SwiftUI

// MARK: - Tab Content Views

struct DefaultTabContentView: View {
    let item: TabBarItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: item.icon)
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.accentColor)
                    
                    Text(item.title ?? item.id.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("This is the content for \(item.title ?? item.id)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Deeplink info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Deeplink Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Deeplink: \(item.deeplink)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle(item.title ?? item.id.capitalized)
    }
}

struct HomeView: View {
    let item: TabBarItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Home-specific content
                VStack(spacing: 16) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.blue)
                    
                    Text("Welcome Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("This is your home dashboard with personalized content and quick access to your most used features.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Home features
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    FeatureCard(
                        icon: "chart.bar.fill",
                        title: "Analytics",
                        description: "View your data"
                    )
                    
                    FeatureCard(
                        icon: "bell.fill",
                        title: "Notifications",
                        description: "Stay updated"
                    )
                    
                    FeatureCard(
                        icon: "star.fill",
                        title: "Favorites",
                        description: "Quick access"
                    )
                    
                    FeatureCard(
                        icon: "gear",
                        title: "Settings",
                        description: "Customize app"
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Home")
    }
}

struct SearchView: View {
    let item: TabBarItem
    
    var body: some View {
        VStack(spacing: 24) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search...", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            // Search results placeholder
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<10, id: \.self) { index in
                        SearchResultCard(
                            title: "Search Result \(index + 1)",
                            subtitle: "This is a sample search result",
                            icon: "doc.text"
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Search")
    }
}

struct FavoritesView: View {
    let item: TabBarItem
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<8, id: \.self) { index in
                    FavoriteItemCard(
                        title: "Favorite Item \(index + 1)",
                        subtitle: "This is one of your favorite items",
                        icon: "heart.fill"
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .navigationTitle("Favorites")
    }
}

struct ProfileView: View {
    let item: TabBarItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile header
                VStack(spacing: 16) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        )
                    
                    Text("John Doe")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("john.doe@example.com")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Profile options
                VStack(spacing: 12) {
                    ProfileOptionRow(
                        icon: "person.circle",
                        title: "Edit Profile",
                        action: {}
                    )
                    
                    ProfileOptionRow(
                        icon: "bell",
                        title: "Notifications",
                        action: {}
                    )
                    
                    ProfileOptionRow(
                        icon: "lock",
                        title: "Privacy & Security",
                        action: {}
                    )
                    
                    ProfileOptionRow(
                        icon: "questionmark.circle",
                        title: "Help & Support",
                        action: {}
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Profile")
    }
}

struct SettingsView: View {
    let item: TabBarItem
    
    var body: some View {
        List {
            Section("General") {
                SettingsRow(
                    icon: "bell",
                    title: "Notifications",
                    value: "On"
                )
                
                SettingsRow(
                    icon: "moon",
                    title: "Dark Mode",
                    value: "Auto"
                )
                
                SettingsRow(
                    icon: "globe",
                    title: "Language",
                    value: "English"
                )
            }
            
            Section("Privacy") {
                SettingsRow(
                    icon: "lock",
                    title: "Privacy Policy",
                    value: ""
                )
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Data Usage",
                    value: ""
                )
            }
            
            Section("About") {
                SettingsRow(
                    icon: "info.circle",
                    title: "Version",
                    value: "1.0.0"
                )
                
                SettingsRow(
                    icon: "star",
                    title: "Rate App",
                    value: ""
                )
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Supporting Views

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SearchResultCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct FavoriteItemCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.red)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsRow: View {
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
