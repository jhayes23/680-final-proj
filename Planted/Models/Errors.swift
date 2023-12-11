import Foundation

enum CustomErrors: Error, CaseIterable {
    case invalidUrl
    case noData
    case decodingError
    case deviceError
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .noData:
            return "No data returned from the server"
        case .decodingError:
            return "Invalid server response"
        case .deviceError:
            return "No internet"
        }
    }
}
