import Foundation

struct PlantDataResponse: Decodable {
    let data: [RawPlantElement]
    let to: Int
    let per_page: Int
    let current_page: Int
    let from: Int
    let last_page: Int
    let total: Int
}

struct RawPlantElement: Decodable {
    let id: Int
    let common_name: String
    let scientific_name: [String]
    let other_name: [String]
    let cycle: String
    let watering: String
    let sunlight: [String]
    let default_image: PlantImage
}

struct PlantOverView: Identifiable, Decodable, Hashable, Comparable {
    let id: Int
    let common_name: String
    let scientific_name: [String]
    let other_name: [String]
    let cycle: String
    let watering: String
    let sunlight: [String]
    let default_image: PlantImage
    
    init?(_ rawElement: RawPlantElement){
        self.id = rawElement.id
        self.common_name = rawElement.common_name.capitalized
        self.scientific_name = rawElement.scientific_name
        self.other_name = rawElement.other_name
        self.cycle = rawElement.cycle
        self.watering = rawElement.watering
        self.sunlight = rawElement.sunlight
        self.default_image = rawElement.default_image
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(id)" + common_name)
    }
    static func == (lhs: PlantOverView, rhs: PlantOverView) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: PlantOverView, rhs: PlantOverView) -> Bool {
        return lhs.common_name < rhs.common_name
    }
}


struct PlantDetail: Identifiable, Codable {
    let id: Int
    let common_name: String?
    let scientific_name: [String]?
    let other_name: [String]?
    let family: String?
    let origin: [String]?
    let type: String?
    let cycle: String?
    let watering: String?
    let sunlight: [String]?
    let soil: [String]?
    let propagation: [String]?
    let description: String?
    let maintenance: String?
    let care_level: String?
    let default_image: PlantImage?
    
}

struct PlantImage: Codable {
    let license: Int
    let licenseName: String?
    let licenseURL: String?
    let originalURL: String?
    let regularURL: String?
    let medium_url: String?
    let smallURL: String?
    let thumbnail: String?
}

