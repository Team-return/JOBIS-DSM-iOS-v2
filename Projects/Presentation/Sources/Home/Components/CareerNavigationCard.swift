import UIKit
import SnapKit
import Then
import DesignSystem

enum CardSize {
    case small(type: CardType)
    case large

    enum CardType {
        case findCompanys
        case findWinterRecruitments
    }
}

final class CareerNavigationCard: UIButton {
    private let headerLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private let iconView = UIView().then {
        $0.backgroundColor = .GrayScale.gray10
        $0.layer.cornerRadius = 32
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
    }
    private let iconImageView = UIImageView()

    public init(
        style: CardSize
    ) {
        super.init(frame: .zero)
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 12

        setCard(style: style)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setCard(style: CardSize) {
        var info: (text: String, icon: JobisIcon) {
            switch style {
            case let .small(type):
                switch type {
                case .findCompanys:
                    return ("다른 기업들\n탐색 하기 →", .officeBuilding)
                case .findWinterRecruitments:
                    return ("체험형\n현장실습 →", .snowman)
                }
            case .large:
                return ("다른 기업들은 어떨까?\n다른 기업들 둘러 보러 가기 →", .officeBuilding)
            }
        }

        headerLabel.setJobisText(info.text, font: .headLine, color: .GrayScale.gray90)
        iconImageView.image = .jobisIcon(info.icon)
            .resize(.init(width: 40, height: 40))
    }

    override func layoutSubviews() {
        [iconView, headerLabel].forEach(addSubview(_:))
        iconView.addSubview(iconImageView)

        headerLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20)
        }
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        iconView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(64)
        }
    }
}
