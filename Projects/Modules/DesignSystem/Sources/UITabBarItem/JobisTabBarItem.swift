import UIKit

public enum JobisTabBarType: Int {
    case home = 0
    case recruitment
    case review
    case bookmark
    case myPage
}

private extension JobisTabBarType {
    // swiftlint: disable large_tuple
    func tabItemTuple() -> (String, UIImage, Int) {
        switch self {
        case .home:
            return ("홈", DesignSystemAsset.Icons.homeTab.image, 0)

        case .recruitment:
            return ("모집의뢰서", DesignSystemAsset.Icons.recruitmentTab.image, 1)

        case .review:
            return ("후기", DesignSystemAsset.Icons.reviewTab.image, 2)

        case .bookmark:
            return ("북마크", DesignSystemAsset.Icons.bookmarkTab.image, 3)

        case .myPage:
            return ("마이페이지", DesignSystemAsset.Icons.mypageTab.image, 4)
        }
    }
    // swiftlint: enable large_tuple
}

public class JobisTabBarItem: UITabBarItem {
    public init(_ type: JobisTabBarType) {
        super.init()
        let (title, image, tag) = type.tabItemTuple()

        self.title = title
        self.image = image
        self.tag = tag
        self.setTitleTextAttributes([.font: UIFont.jobisFont(.caption)], for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
