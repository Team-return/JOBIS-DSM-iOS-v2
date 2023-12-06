import Foundation

public extension Int {
    func secondToMinutes() -> String {
        self == 0 ? "" : self % 60 < 10 ?
        "0\(self/60):0\(self%60)" :
        "0\(self/60):\(self%60)"
    }
}
