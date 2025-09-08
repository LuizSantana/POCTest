import SwiftUI

// MARK: - Default TabBar View (ComponentStyle Pattern)
struct DefaultTabBarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let configuration: TabBarStyleConfiguration
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(configuration.items) { item in
                DefaultTabBarItemView(
                    item: item,
                    isSelected: item.id == configuration.selectedItem?.id,
                    onTap: { configuration.onItemSelected(item) }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, horizontalSizeClass == .compact ? 12 : 16)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        )
        .opacity(configuration.state.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: configuration.state)
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
    }
}

// MARK: - Compact TabBar View
struct CompactTabBarView: View {
    let configuration: TabBarStyleConfiguration
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(configuration.items) { item in
                CompactTabBarItemView(
                    item: item,
                    isSelected: item.id == configuration.selectedItem?.id,
                    onTap: { configuration.onItemSelected(item) }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .opacity(configuration.state.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: configuration.state)
    }
}

// MARK: - Floating TabBar View (ComponentStyle Pattern)
struct FloatingTabBarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let configuration: TabBarStyleConfiguration
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(configuration.items) { item in
                FloatingTabBarItemView(
                    item: item,
                    isSelected: item.id == configuration.selectedItem?.id,
                    onTap: { configuration.onItemSelected(item) }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, horizontalSizeClass == .compact ? 12 : 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(materialBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(borderColor, lineWidth: 0.5)
                )
        )
        .padding(.horizontal, horizontalSizeClass == .compact ? 16 : 20)
        .padding(.bottom, 34) // Safe area bottom padding
        .opacity(configuration.state.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: configuration.state)
    }
    
    private var materialBackground: Material {
        colorScheme == .dark ? .ultraThinMaterial : .regularMaterial
    }
    
    private var borderColor: Color {
        Color(.separator).opacity(colorScheme == .dark ? 0.5 : 0.3)
    }
}

// MARK: - Minimal TabBar View
struct MinimalTabBarView: View {
    let configuration: TabBarStyleConfiguration
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(configuration.items) { item in
                MinimalTabBarItemView(
                    item: item,
                    isSelected: item.id == configuration.selectedItem?.id,
                    onTap: { configuration.onItemSelected(item) }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.clear)
        .opacity(configuration.state.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: configuration.state)
    }
}

// MARK: - TabBar Item Views
struct DefaultTabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                
                if let title = item.title {
                    Text(title)
                        .font(.caption2)
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CompactTabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: .medium))
                
                if let title = item.title {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.accentColor : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FloatingTabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .primary)
                
                if let title = item.title {
                    Text(title)
                        .font(.caption2)
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MinimalTabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                
                if let title = item.title {
                    Text(title)
                        .font(.caption2)
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}