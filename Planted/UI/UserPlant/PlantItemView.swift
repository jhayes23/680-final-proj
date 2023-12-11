import SwiftUI

struct PlantItemView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject
    var store: Store
    @State private var showPopUp = false

    @State private var plantRemove = false
    
    var plantItem: PlantItem
    
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: plantItem.detailImage)){ phase in
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
                        Text(plantItem.common_name).font(.title)
                    }.padding(.top, 12)
                    
                    HStack{
                        Text(plantItem.scientific_name).font(.title2)
                    }
                    HStack{
                        Text(plantItem.other_name)
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
                                Text(plantItem.origin ?? "Unavailable")
                            }.padding(.leading, 30)
                            
                        }
                        .padding(.bottom, 10)
                        HStack{
                            Image(systemName: "figure.2.and.child.holdinghands")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 12)
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading) {
                                Text("Plant Family")
                                Text(plantItem.plantFamily ?? "Unavailable")
                            }.padding(.leading, 30)
                            
                        }
                        .padding(.bottom, 10)
                        HStack{
                            Image(systemName: "arrow.3.trianglepath")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 12)
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading) {
                                Text("Cycle")
                                Text(plantItem.cycle)
                            }.padding(.leading, 30)
                        }
                        .padding(.bottom, 10)
                        HStack{
                            Image(systemName: "drop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 12)
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading) {
                                Text("Watering")
                                Text(plantItem.watering)
                            }.padding(.leading, 30)
                        }
                        .padding(.bottom, 10)
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
                                Text(plantItem.soil)
                            }.padding(.leading, 30)
                        }
                        .padding(.bottom, 10)
                        HStack{
                            Image(systemName: "sun.max.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 12)
                                .padding(.trailing, 8)
                            
                            
                            VStack(alignment: .leading) {
                                Text("Sunlight")
                                Text(plantItem.sunlight)
                            }.padding(.leading, 30)
                            
                            
                        }
                        .padding(.bottom, 10)
                        HStack{
                            Image(systemName: "hammer.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 12)
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading) {
                                Text("Maintenance")
                                Text(plantItem.maintenance)
                            }.padding(.leading, 30)
                            
                        }
                        .padding(.bottom, 10)
                        HStack{
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 12)
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading) {
                                Text("Care Level")
                                Text(plantItem.careLevel)
                            }.padding(.leading, 30)
                            
                            
                        }
                        .padding(.bottom, 10)
                        HStack{
                            
                            Text(" Info: \n \(plantItem.desc)")
                                .padding(15)
                                .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        }
                    }
                }
                    .background(Rectangle().foregroundColor(Color(UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 0.96))))
                    .cornerRadius(20)
                    .shadow(radius: 15)
                
                Button("Create a Water Reminder"){
                    showPopUp.toggle()
                }.padding(25)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.gray, radius: 3, x: 1, y: 1)
                    .popover(isPresented: $showPopUp) {
                        CreateReminder(showPopUp: $showPopUp, referenceId: plantItem.refId)
                    .padding()}
                    Spacer()
                    Button("Remove from My Plants"){
                        plantRemove.toggle()
                    }.foregroundColor(.white)
                        .padding(28)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(color: Color.gray, radius: 3, x: 1, y: 1)
                        .alert(isPresented: $plantRemove){
                            Alert(
                                title: Text("Confirm removal"),
                                message: Text("Are you sure you want to remove this plant?"),
                                primaryButton: .default(Text("Yes")){
                                    remove()
                                },
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                }
                
            }                .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width < -100 {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
        }
        
        func remove(){
            do{
                try store.deleteWateringReminders(for: plantItem.refId)
                try store.delete(plantItemWithId: plantItem.id)
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error removing plant from list")
            }
            
        }
    }
