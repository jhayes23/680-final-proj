import SwiftUI

struct SimplePlantBox: View {
    
    var plantName: String
    var plantURL: String
    var plantSciName: String
    
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
            Spacer(minLength: 1.0)
            VStack{
                Text(plantName)
                    .font(.title)
                    .foregroundColor(Color(red: 34 / 255, green: 200 / 255, blue: 34 / 255))
                Text(plantSciName)
                    .font(.title3)
                    .foregroundColor(Color(red: 34 / 255, green: 200 / 255, blue: 34 / 255))
            }
            Spacer()
        }
        .padding([.top,.bottom])
        .background(Rectangle().foregroundColor(Color(UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 0.66))))
        .cornerRadius(20)
        .shadow(radius: 15)
        .padding([.top, .leading, .trailing])
    }
}

