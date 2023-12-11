import Foundation
struct Plants {
    func searchPlants(query: String)  async throws -> [PlantOverView]{
        let urlString = "https://perenual.com/api/species-list?key=\(Constants.apiKey)&q=\(query)"
        guard let url = URL(string: urlString) else {
            throw CustomErrors.invalidUrl
        }
        
        let (data, _ ) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        
        let plantsResponse = try decoder.decode(PlantDataResponse.self, from: data)

        let plants = plantsResponse.data.compactMap { plantData in
            PlantOverView(plantData)
        }
    
        return  Array(Set(plants))
    }

    func getPlantDetails(plantId: Int) async throws -> PlantDetail {
        let urlString = "https://perenual.com/api/species/details/\(plantId)?key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw CustomErrors.invalidUrl
        }
        
        let (data, _ ) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let plantsResponse = try decoder.decode(PlantDetail.self, from: data)
        return plantsResponse
    }
}
