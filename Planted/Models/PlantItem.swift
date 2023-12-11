import Foundation

struct PlantItem: Hashable , Identifiable, Codable {
    let id: UUID
    let refId: Int
    let common_name: String
    let scientific_name: String
    let other_name: String
    let plantFamily: String?
    let origin: String?
    let plantType: String
    let cycle: String
    let watering: String
    let sunlight: String
    let propagation: String
    let soil: String
    let maintenance: String
    let careLevel: String
    let desc: String
    let smallThumbnail: String
    let detailImage: String
}
