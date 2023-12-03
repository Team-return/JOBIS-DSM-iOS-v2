import RxSwift

public extension Observable<String> {
    func limit(_ max: Int, onComplete: @escaping () -> Void) -> Observable<String> {
        scan("") { old, new in
            if old.count == max - 1 && new.count == max { onComplete() }
            return new.count <= max || new.isEmpty ? new: old
        }
    }
}
