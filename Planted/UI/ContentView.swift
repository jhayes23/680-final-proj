import SwiftUI

enum myTabs: Int {
    case myPlants
    case search
    case reminders
}

struct ContentView: View {
    @State private var currentTab: myTabs = .myPlants
    
    var body: some View {
        NavigationView {
            
            TabView(selection: $currentTab) {
                MyPlantsView()
                    .tabItem {
                        Label("My Plants", systemImage: "leaf")
                    }
                    .tag(myTabs.myPlants)
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(myTabs.search)
                
                ReminderView()
                    .tabItem {
                        Label("Reminders", systemImage: "bell")
                    }
                    .tag(myTabs.reminders)
            }.frame(maxHeight: .infinity)
            
        }
        .navigationBarHidden(false)

    }
}
