import UIKit
import SnapKit
import Then
import DesignSystem

final class ReviewInfoView: UIView {
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    private let companyLabel = UILabel()
    private let areaLabel = UILabel()
    private let interviewTypeLabel = UILabel()
    private let interviewerLabel = UILabel()

    private let dot1 = UILabel()
    private let dot2 = UILabel()
    private let dot3 = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        [dot1, dot2, dot3].forEach { $0.text = " • " }
        [companyLabel, dot1, areaLabel, dot2, interviewTypeLabel, dot3, interviewerLabel]
            .forEach { stackView.addArrangedSubview($0) }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(company: String, area: String, interviewType: String, interviewerCount: Int) {
        companyLabel.setJobisText(company, font: .subBody, color: UIColor.GrayScale.gray70)
        areaLabel.setJobisText(area, font: .subBody, color: UIColor.GrayScale.gray70)
        interviewTypeLabel.setJobisText(interviewType, font: .subBody, color: UIColor.GrayScale.gray70)
        interviewerLabel.setJobisText("면접관 수: \(interviewerCount)명", font: .subBody, color: UIColor.GrayScale.gray70)
    }
}
