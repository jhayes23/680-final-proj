import SwiftUI

struct MyPlantsView: View {
    @EnvironmentObject var store: Store
    
    @State private var plantsItems: [PlantItem] = []
    
    @State private var searchText: String = ""
    private var filteredPlants: [PlantItem] {
        if searchText.isEmpty {
            return plantsItems
        } else {
            return plantsItems.filter { $0.common_name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                GeometryReader { geometry in
                    VStack{
                        HStack {
                            TextField("Filter", text: $searchText)
                            Button(action: {
                                searchText = ""
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            })
                            .padding([.leading, .trailing])
                            .opacity(searchText.isEmpty ? 0 : 1)
                        }
                        .frame(width: 350)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 1) {
                                ForEach(filteredPlants, id: \.self) { plant in
                                    NavigationLink(destination: PlantItemView(plantItem: plant)){
                                        let sciName = plant.scientific_name.split(separator: " ").map { String($0) }
                                        SimplePlantBox(
                                            plantName: plant.common_name,
                                            plantURL: plant.smallThumbnail,
                                            plantSciName: sciName.joined(separator: " ")
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                        .frame(height: geometry.size.height * 0.95)
                    }
                }
            }.onAppear {
                do {
                    plantsItems = try store.fetchPlantItems()
                } catch {
                }
            }
        }}}

