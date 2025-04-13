import Foundation

enum ClassCategory: Int {
    case softwareDev1 = 1
    case softwareDev2
    case embedded
    case ai

    var title: String {
        switch self {
        case .softwareDev1: return "소프트웨어 개발 1반"
        case .softwareDev2: return "소프트웨어 개발 2반"
        case .embedded: return "임베디드 소프트웨어 3반"
        case .ai: return "인공지능 소프트웨어 4반"
        }
    }
}
