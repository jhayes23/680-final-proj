import SwiftUI
struct Constants {
    
}


@main
struct PlantedApp: App {
    
    
    let store = Store()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
