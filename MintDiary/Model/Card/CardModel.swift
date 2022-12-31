import Foundation

protocol CardModel: Equatable, Codable {
    var level: Int { get set }
    var column: Int { get set }
}
