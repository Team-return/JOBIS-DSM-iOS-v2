import RxSwift

public extension Observable<String> {
    func limitWithOnlyInt(_ max: Int, onComplete: @escaping () -> Void) -> Observable<String> {
        scan("") { old, new in
            if old.count == max - 1 && new.count == max { onComplete() }
            return (new.count <= max && new ~= "^[0-9]+") || new.isEmpty ? new: old
        }
    }
}
