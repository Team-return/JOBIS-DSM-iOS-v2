import UIKit
import Domain

import DesignSystem

public struct RecentCompanyItem: Equatable {
    public let entity: RecentCompanyEntity

    public init(entity: RecentCompanyEntity) {
        self.entity = entity
    }
}
