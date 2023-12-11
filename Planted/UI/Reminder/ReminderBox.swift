import SwiftUI

struct ReminderBox: View {
    var waterReminder: WateringReminder
    var plantName: String
    var plantURL: String
    var nextWatering: Date
    @State private var markPopUp = false

    var body: some View {
        HStack(alignment: .center) {
                        AsyncImage(url: URL(string: plantURL)){ phase in
                            switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(20)
                                        .frame(maxWidth: 160, maxHeight: 120)
            
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    EmptyView()
                                }
                        }
            VStack(alignment: .leading){
                Text(plantName)
                    .font(.title)
                    .foregroundColor(Color(red: 34 / 255, green: 200 / 255, blue: 34 / 255))
                Text(formatDate(date: nextWatering))
                    .font(.title3)
                    .foregroundColor(Color(red: 34 / 255, green: 200 / 255, blue: 34 / 255))
            }
        } .padding()
            .background(Rectangle().foregroundColor(Color(UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 0.66))))
            .cornerRadius(20)
            .shadow(radius: 15).onTapGesture {
                markPopUp.toggle()
            }.popover(isPresented: $markPopUp) {
                markReminder(markPopUp: $markPopUp, wateringReminder: waterReminder)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)}
    }
    func formatDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy h a"
            return formatter.string(from: date)
        }
        
    }

