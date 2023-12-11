import SwiftUI

struct PlantDetailedView: View {
    
    
    @EnvironmentObject
    var store: Store
    @State private var plantsItems: [PlantItem] = []
    @State private var showButton = false
    var plantId: Int
    @State private var details: PlantDetail?
    @State private var savedPlantId: UUID?
    
    var body: some View {
        
        ScrollView{
            
            VStack{
                if let details = details{
                    AsyncImage(url: URL(string: details.default_image?.medium_url ??  "")){ phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(20)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    
                    VStack{
                        HStack{
                            Text(details.common_name?.capitalized ?? "Unavailable").font(.title)
                        }.padding(.top, 12)
                        HStack{
                            Text(details.scientific_name?.joined(separator: ", ") ?? "Unavailable").font(.title2)
                        }
                        HStack{
                            Text(details.other_name?.joined(separator: ", ") ?? "Unavailable")
                        }
                        
                        VStack(alignment: .leading, spacing: 8){
                            HStack{
                                Image(systemName: "globe")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading) {
                                        Text("Origin")
                                    Text(details.origin?.joined(separator: ", ") ?? "Unavailable")
                                }.padding(.leading, 30)
                                
                               
                                
                                
                                
                            }
                            HStack{
                                Image(systemName: "figure.2.and.child.holdinghands")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading) {
                                        Text("Plant Family")
                                    Text(details.family?.capitalized ?? "Unavailable")
                                }.padding(.leading, 30)
                                
                                
                                
                            }
                            HStack{
                                Image(systemName: "arrow.3.trianglepath")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading) {
                                        Text("Cycle")
                                    Text(details.cycle ?? "Unavailable")
                                }.padding(.leading, 30)
                                
                                
                                
                            }
                            HStack{
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading) {
                                        Text("Watering")
                                    Text(details.watering ?? "Unavailable".capitalized)
                                }.padding(.leading, 30)
                                
                                
                                
                            }
                            HStack{
                                Image(systemName: "moonphase.last.quarter.inverse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .rotationEffect(.degrees(270))
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading) {
                                        Text("Soil")
                                    Text(details.soil?.isEmpty == false ? details.soil!.joined(separator: ", ").capitalized : "Unavailable")
                                }.padding(.leading, 30)
                                
                                
                                
                            }
                            HStack{
                                Image(systemName: "sun.max.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading) {
                                        Text("Sunlight")
                                    Text(details.sunlight?.isEmpty == false ? details.sunlight!.joined(separator: ", ").capitalized : "Unavailable")
                                }.padding(.leading, 30)
                                

                            }
                            HStack{
                                Image(systemName: "hammer.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading) {
                                        Text("Maintenance")
                                    Text(details.maintenance ?? "Unavailable")
                                }.padding(.leading, 30)
                                
                                
                            }
                            HStack{
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading) {
                                        Text("Care Level")
                                    Text((details.care_level ?? "Unavailable").capitalized)
                                }.padding(.leading, 30)
                                
                                
                            }
                            HStack{
                                
                                Text(" Info: \n \(details.description ?? "Unavailable")")
                                    .padding(15)
                                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                            }
                        }
                    }
                        .background(Rectangle().foregroundColor(Color(UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 0.66))))
                        .cornerRadius(20)
                        .shadow(radius: 15)
                    
                    
                    if !showButton {
                        Button("Add to My Plants"){
                            addPlantToStorage(data: details)
                        }.padding(25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: Color.gray, radius: 3, x: 1, y: 1)
                    } else {
                        Button("Saved in My Plants"){
                            removeWaterings(idToRemove: details.id)
                        }.padding(25)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .shadow(color: Color.gray, radius: 3, x: 1, y: 1)
                        
                    }
                }
                
            }
        }
        .onAppear(){
            do {
                fetchData()
                    plantsItems = try store.fetchPlantItems()
                    showButton = plantsItems.contains { $0.refId == plantId }
                    self.savedPlantId = plantsItems.first { $0.refId == plantId }?.id
            } catch {
                
            }
            }
        
    }
    func fetchData() {
        Task {
            do {
                let fetchedDetails = try await Plants().getPlantDetails(plantId: plantId)
                details = fetchedDetails
            } catch {
                print("Error fetching plant details: \(error)")
            }
        }
    }
    
    func addPlantToStorage(data: PlantDetail){

        let item: PlantItem = PlantItem( id: UUID(),
                                         refId: data.id ,
                                         common_name: data.common_name?.capitalized ?? "Unavailable",
                                         scientific_name: data.scientific_name?.isEmpty == false ? data.scientific_name!.joined(separator: ", ").capitalized : "Unavailable",
                                         other_name: data.other_name?.isEmpty == false ? data.other_name!.joined(separator: ", ").capitalized : "",
                                         plantFamily: data.family?.capitalized ?? "Unavailable",
                                         origin: data.origin?.isEmpty == false ? data.origin!.joined(separator: ", ").capitalized : "Unavailable",
                                         plantType: data.type ?? "Unavailable",
                                         cycle: data.cycle ?? "Unavailable",
                                         watering: data.watering ?? "Unavailable",
                                         sunlight: data.sunlight?.isEmpty == false ? data.sunlight!.joined(separator: ", ").capitalized : "Unavailable",
                                         propagation: data.propagation?.isEmpty == false ? data.propagation!.joined(separator: ", ").capitalized : "Unavailable",
                                         soil: data.soil?.isEmpty == false ? data.soil!.joined(separator: ", ").capitalized : "Unavailable",
                                         maintenance: data.maintenance ?? "Unavailable",
                                         careLevel: data.care_level ?? "Unavailable",
                                         desc: data.description ?? "Unavailable",
                                         smallThumbnail: data.default_image?.thumbnail ?? "Unavailable",
                                         detailImage: data.default_image?.medium_url ?? "Unavailable")
        
        do {
            try store.insert(item)
            showButton.toggle()
        } catch {
            
        }
    }
    
    func removeWaterings(idToRemove: Int){
        do{
            try store.deleteWateringReminders(for: idToRemove)
            try store.delete(plantItemWithId: savedPlantId!)
            showButton.toggle()
        } catch {
            print("Error removing plant from list")
        }
        
    }
}
