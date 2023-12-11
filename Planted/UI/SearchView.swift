import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    let planty = Plants()
    @State private var getMatches: [PlantOverView] = []
    @State private var errorString: String?
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            performSearch(query: newValue)
                        }
                    
                    Button(action: {
                        searchText = ""
                        getMatches = []
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
                        ForEach(getMatches, id: \.self) { plant in
                            NavigationLink(destination: PlantDetailedView(plantId: plant.id)) {
                                SimplePlantBox(plantName: plant.common_name, plantURL: plant.default_image.thumbnail ?? "", plantSciName: plant.scientific_name.joined(separator: ", "))
                            }
                        }
                        
                    }
                }.padding(.bottom)
            }
        }
    }
    
    func performSearch(query: String) {
        Task {
            do {
                if !query.isEmpty {
                    getMatches = try await planty.searchPlants(query: query).sorted()
                } else {
                    getMatches = []
                }
            } catch {
                errorString = "\(error)"
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
