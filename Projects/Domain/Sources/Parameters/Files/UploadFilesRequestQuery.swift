import Foundation

public struct UploadFileModel {
    public let file: Data
    public let fileName: String

    public init(file: Data, fileName: String) {
        self.file = file
        self.fileName = fileName
    }
}

public struct UploadFilesRequestDTO: Encodable {
    public let files: [FileRequestDTO]

    public init(files: [FileRequestDTO]) {
        self.files = files
    }
}

public struct FileRequestDTO: Encodable {
    public let type = "EXTENSION_FILE"
    public let fileName: String

    public init(fileName: String) {
        self.fileName = fileName
    }

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case type
    }
}

public extension [UploadFileModel] {
    func toRequestDTO() -> [FileRequestDTO] {
        self.map { .init(fileName: $0.fileName) }
    }
}
