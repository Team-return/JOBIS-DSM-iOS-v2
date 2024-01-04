import UIKit
import SnapKit
import Then
import DesignSystem

final class EmploymentView: UIView {
    private let employmentLabel = UILabel().then {
        $0.setJobisText("현재 대마고의 취업률", font: .subBody, color: .GrayScale.gray90)
    }
    private let employmentPercentageLabel = UILabel().then {
        $0.setJobisText("0.0 %", font: .headLine, color: .Primary.blue20)
    }
    private let arrowNavigateImageView = UIImageView().then {
        // TODO: 네비게이트 생기면 isHidden = false 로 바꿔야함
        /// 버튼으로 바꾸기도 해야할 듯
        $0.isHidden = true
        $0.image = .jobisIcon(.arrowNavigate)
    }

    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 12
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setEmploymentPercentage(_ percentage: Float) {
        let str = String(format: "%.1f", percentage)
        employmentPercentageLabel.text = "\(str) %"
    }

    override func layoutSubviews() {
        [
            employmentLabel,
            employmentPercentageLabel,
            arrowNavigateImageView
        ].forEach(self.addSubview(_:))

        employmentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        employmentPercentageLabel.snp.makeConstraints {
            $0.top.equalTo(employmentLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(20)
        }

        arrowNavigateImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(28)
        }
    }
}
