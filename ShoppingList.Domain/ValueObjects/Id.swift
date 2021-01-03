import Foundation

public struct Id<T>: Hashable {
    private let uuid: UUID

    private init(_ uuid: UUID) {
        self.uuid = uuid
    }

    public func toUuid() -> UUID {
        uuid
    }

    public func toString() -> String {
        uuid.uuidString
    }
}

extension Id {
    public static func fromUuid(_ uuid: UUID) -> Self {
        .init(uuid)
    }

    public static func random() -> Self {
        .init(.init())
    }
}
