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
    private var headerLabelTexts = [String]()
    private var iconView = UIView().then {
        $0.backgroundColor = .GrayScale.gray10
        $0.asCircle()
    }
    private var icon = UIImageView()

    public init(
        style: CardSize
    ) {
        super.init(frame: .zero)
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 12

        var info: (textArr: [String], icon: JobisIcon) {
            switch style {
            case let .small(type):
                switch type {
                case .findCompanys:
                    return (["다른 기업들", "탐색 하기 →"], .officeBuilding)
                case .findWinterRecruitments:
                    return (["체험형", "현장실습 →"], .snowman)
                }
            case .large:
                return (["다른 기업들은 어떨까?", "다른 기업들 둘러 보러 가기 →"], .officeBuilding)
            }
        }

        headerLabelTexts = info.textArr
        icon.image = .jobisIcon(info.icon).resize(.init(width: 40, height: 40))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        let headerLabels: [UILabel] = headerLabelTexts.map { text in
            let label = UILabel()
            label.setJobisText(text, font: .headLine, color: .GrayScale.gray90)
            return label
        }
        (headerLabels + [iconView]).forEach(addSubview(_:))
        iconView.addSubview(icon)

        headerLabels.indices.forEach { index in
            if headerLabels[index] == headerLabels.first {
                headerLabels[index].snp.makeConstraints {
                    $0.top.leading.equalToSuperview().offset(20)
                }
            } else {
                headerLabels[index].snp.makeConstraints {
                    $0.top.equalTo(headerLabels[index - 1].snp.bottom)
                    $0.leading.equalTo(headerLabels[index - 1])
                }
            }
        }
        iconView.snp.makeConstraints {
            $0.top.equalTo(headerLabels.last!.snp.bottom).offset(16)
            $0.bottom.trailing.equalToSuperview().inset(20)
        }
        iconView.asCircle()
        icon.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
}
