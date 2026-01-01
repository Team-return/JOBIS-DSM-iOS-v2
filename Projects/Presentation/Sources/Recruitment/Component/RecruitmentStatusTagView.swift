import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

enum RecruitmentStatus {
    case recruiting
    case done
    case none

    var text: String {
        switch self {
        case .recruiting: return "모집중"
        case .done: return "모집 종료"
        case .none: return ""
        }
    }

    var textColor: UIColor {
        switch self {
        case .recruiting: return .Primary.blue20
        case .done: return .GrayScale.gray60
        case .none: return .clear
        }
    }

    var borderColor: UIColor {
        switch self {
        case .recruiting: return .Primary.blue20
        case .done: return .GrayScale.gray50
        case .none: return .clear
        }
    }
}

class RecruitmentStatusTagView: BaseView {
    private let contentView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Primary.blue20.cgColor
    }
    private let label = UILabel().then {
        $0.setJobisText("-", font: .description, color: .Primary.blue20)
        $0.textAlignment = .center
    }

    private var status: RecruitmentStatus = .recruiting {
        didSet {
            updateUI()
        }
    }

    override func addView() {
        addSubview(contentView)
        contentView.addSubview(label)
    }

    override func setLayout() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(
            width: labelSize.width + 32,
            height: labelSize.height + 12
        )
    }

    func configure(with status: RecruitmentStatus) {
        self.status = status
    }

    private func updateUI() {
        label.text = status.text
        label.textColor = status.textColor
        contentView.layer.borderColor = status.borderColor.cgColor
        isHidden = (status == .none)
        invalidateIntrinsicContentSize()
    }
}
