import Foundation

// swiftlint:disable all
public extension Int {
    func extract(_ k: Int) -> Int {
        let n = self
        return (n / Int(pow(10.0, Float(k - 1)))) % 10
    }
}
//swiftlint:enable all
