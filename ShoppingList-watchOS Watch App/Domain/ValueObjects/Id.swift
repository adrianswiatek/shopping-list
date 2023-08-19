import Foundation

struct Id<T>: Equatable, Hashable {
    private let uuid: UUID

    private init(uuid: UUID) {
        self.uuid = uuid
    }

    static func fromString(_ string: String) -> Id<T> {
        guard let uuid = UUID(uuidString: string) else {
            preconditionFailure("Invalid string value")
        }
        return .init(uuid: uuid)
    }

    static func fromUuid(_ uuid: UUID) -> Id<T> {
        .init(uuid: uuid)
    }

    static func random() -> Id<T> {
        .init(uuid: UUID())
    }

    func asString() -> String {
        uuid.uuidString
    }

    func asUuid() -> UUID {
        uuid
    }
}
