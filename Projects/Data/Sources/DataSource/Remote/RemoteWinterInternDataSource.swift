import Foundation
import RxSwift
import Domain

protocol RemoteWinterInternDataSource {
    func fetchWinterInternSeason() -> Single<Bool>
}

final class RemoteWinterInternDataSourceImpl: RemoteBaseDataSource<WinterInternAPI>, RemoteWinterInternDataSource {
    func fetchWinterInternSeason() -> Single<Bool> {
        return request(.fetchWinterInternSeason)
            .map { response -> Bool in
                if let data = try? JSONDecoder().decode(Bool.self, from: response.data) {
                    return data
                } else {
                    print("failed to load winterInterSeason")
                    return false
                }
            }
    }

}
