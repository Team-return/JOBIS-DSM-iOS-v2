import UIKit
import Foundation

public extension UIImage {
    static func jobisIcon(_ icon: JobisIcon) -> UIImage {
        icon.uiImage()
    }
}

public enum JobisIcon {
    case arrowRight
    case arrowNavigate
    case door
    case bugBox
    case bugReport
    case changePassword
    case withdrawal
    case logout
    case code
    case bookmarkOn
    case bookmarkOff
    case searchIcon
    case filterIcon
    case profile
    case bell
    case officeBuilding
    case snowman
    case jobisLogo
    case currentPageControl
    case defaultPageControl
    case pieChart
    case trash
    case emptyBookmark

    // swiftlint: disable cyclomatic_complexity
    func uiImage() -> UIImage {
        let dsIcons = DesignSystemAsset.Icons.self

        switch self {
        case .arrowRight:
            return dsIcons.arrowRight.image

        case .arrowNavigate:
            return dsIcons.arrowNavigate.image

        case .door:
            return dsIcons.door.image

        case .bugBox:
            return dsIcons.bugBox.image

        case .bugReport:
            return dsIcons.bugReport.image

        case .changePassword:
            return dsIcons.changePassword.image

        case .code:
            return dsIcons.code.image

        case .withdrawal:
            return dsIcons.withdrawal.image

        case .logout:
            return dsIcons.logout.image

        case .bookmarkOn:
            return dsIcons.bookmarkOn.image

        case .bookmarkOff:
            return dsIcons.bookmarkOff.image

        case .searchIcon:
            return dsIcons.searchIcon.image

        case .filterIcon:
            return dsIcons.filterIcon.image

        case .profile:
            return dsIcons.profile.image

        case .bell:
            return dsIcons.bell.image

        case .officeBuilding:
            return dsIcons.officeBuilding.image

        case .snowman:
            return dsIcons.snowman.image

        case .jobisLogo:
            return dsIcons.jobisLogo.image

        case .currentPageControl:
            return dsIcons.currentPageControl.image

        case .defaultPageControl:
            return dsIcons.defaultPageControl.image

        case .pieChart:
            return dsIcons.pieChart.image

        case .trash:
            return dsIcons.trash.image

        case .emptyBookmark:
            return dsIcons.emptyBookmark.image
        }
    }
    // swiftlint: enable cyclomatic_complexity
}
