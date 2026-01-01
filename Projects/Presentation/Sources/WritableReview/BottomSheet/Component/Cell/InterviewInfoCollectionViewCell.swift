import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class InterviewFormatCollectionViewCell: UICollectionViewCell {
    static let identifier = "InterviewFormatCollectionViewCell"

    public var isCheck: Bool = false {
        didSet {
            if isCheck {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.Primary.blue20.cgColor
                self.formatLabel.setJobisText(
                    getDisplayText(),
                    font: .body,
                    color: UIColor.Primary.blue20
                )
            } else {
                self.layer.borderWidth = 0
                self.formatLabel.setJobisText(
                    getDisplayText(),
                    font: .body,
                    color: UIColor.GrayScale.gray60
                )
            }
        }
    }

    private let formatLabel = UILabel()
    private var interviewFormat: InterviewFormat?
    private var locationType: LocationType?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        self.contentView.addSubview(formatLabel)
    }

    private func setLayout() {
        formatLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func configureView() {
        self.backgroundColor = .ETC.reviewSelection
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 0
    }

    func adapt(format: InterviewFormat) {
        self.interviewFormat = format
        self.locationType = nil
        formatLabel.setJobisText(getDisplayText(), font: .body, color: UIColor.GrayScale.gray60)
    }

    func adapt(location: LocationType) {
        self.locationType = location
        self.interviewFormat = nil
        formatLabel.setJobisText(getDisplayText(), font: .body, color: UIColor.GrayScale.gray60)
    }

    private func getDisplayText() -> String {
        if let format = interviewFormat {
            switch format {
            case .individual:
                return "개인 면접"
            case .group:
                return "단체 면접"
            case .other:
                return "기타 면접"
            }
        } else if let location = locationType {
            switch location {
            case .daejeon:
                return "대전"
            case .seoul:
                return "서울"
            case .gyeonggi:
                return "경기"
            case .other:
                return "기타"
            }
        }
        return ""
    }
}
