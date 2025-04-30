//
//  TabView.swift
//  SMART
//
//  Created by Aryan Palit on 4/29/25.
//
import SwiftUI
import SwiftData

struct TabViewContainer: View {
    @State private var activeTab: TabItem = .home
    @Namespace private var animationNamespace

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content Views based on activeTab
            Group {
                switch activeTab {
                case .home:
                    HomeView()
                case .settings:
                    Text("Settings Content")
                case .notifications:
                    Text("Notifications Content")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .toolbar(.hidden, for: .tabBar) // Hide the default TabView toolbar

            // Custom Interactive Tab Bar
            InteractiveTabBar(activeTab: $activeTab, animationNamespace: _animationNamespace)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // Handle keyboard appearance
        .animation(.easeInOut(duration: 0.2), value: activeTab) // Apply animation to tab changes
    }
}

struct InteractiveTabBar: View {
    @Binding var activeTab: TabItem
    @Namespace var animationNamespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab: tab, activeTab: $activeTab, animationNamespace: animationNamespace)
            }
        }
        .frame(height: 55) // Increased height for better touch target
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background(.background.shadow(.drop(color: .primary.opacity(0.1), radius: 8))) // More subtle shadow
    }

    @ViewBuilder
    func TabButton(tab: TabItem, activeTab: Binding<TabItem>, animationNamespace: Namespace.ID) -> some View {
        let isActive = activeTab.wrappedValue == tab
        VStack(spacing: 4) { // Reduced spacing
            Image(systemName: tab.symbolImage)
                .symbolVariant(.fill)
                .font(.title3) // More standard icon size
                .frame(width: 24, height: 24) // Consistent icon frame
                .foregroundStyle(isActive ? .blue : .secondary)
                .scaleEffect(isActive ? 1.2 : 1.0) // Grow when active
                .animation(.easeInOut(duration: 0.2), value: isActive) // Animate the scale

            Text(tab.rawValue)
                .font(.caption)
                .foregroundStyle(isActive ? .blue : .secondary)
                .scaleEffect(isActive ? 1.2 : 1.0) // Grow when active
                .animation(.easeInOut(duration: 0.2), value: isActive) // Animate the scale
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle()) // Makes the whole area tappable
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) { // Animate the tab change
                activeTab.wrappedValue = tab
            }
        }
    }
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case settings = "Settings"
    case notifications = "Notifications"

    var symbolImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .settings:
            return "gearshape.fill"
        case .notifications:
            return "bell.fill"
        }
    }
}

#Preview {
    let config = ModelConfiguration()
    let container = try! ModelContainer(for: Room.self, configurations: config)
    TabViewContainer()
        .modelContainer(container) // Provide the ModelContainer to TabViewContainer
}
