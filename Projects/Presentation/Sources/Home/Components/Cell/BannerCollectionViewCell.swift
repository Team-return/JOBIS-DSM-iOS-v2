import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

final class BannerCollectionViewCell: BaseCollectionViewCell<HomeBannerItem> {
    static let identifier = "BannerCollectionViewCell"

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    private lazy var passTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        let currentYear = Calendar.current.component(.year, from: Date())
        $0.setJobisText(
            "\(currentYear - 2016)기 대마고\n학생들의 취업률",
            font: .headLine,
            color: .GrayScale.gray90
        )
    }
    private let passLabel = UILabel().then {
        $0.setJobisText(
            " - ",
            font: .headLine,
            color: .Primary.blue20
        )
    }
    public let employStatusButton = JobisButton(style: .main).then {
        $0.setText("현황 보러 가기")
    }
    private let fileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage.jobisIcon(.fileImage)
    }

    override func addView() {
        [
            imageView,
            passTitleLabel,
            passLabel,
            employStatusButton,
            fileImageView
        ].forEach(contentView.addSubview(_:))
    }

    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func totalPassSetLayout() {
        passTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }

        passLabel.snp.makeConstraints {
            $0.top.equalTo(passTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(24)
        }

        employStatusButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(18)
            $0.width.equalTo(151)
            $0.height.equalTo(40)
        }

        fileImageView.snp.makeConstraints {
            $0.width.height.equalTo(180)
            $0.top.trailing.equalToSuperview()
        }
    }

    override func configureView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .GrayScale.gray30
    }

    override func adapt(model: HomeBannerItem) {
        switch model {
        case let .banner(entity):
            // Reset/Setup for Banner
            resetViews()
            setLayout()
            self.imageView.setJobisImage(urlString: entity.bannerURL)
            self.imageView.isHidden = false

        case let .totalPass(entity):
            // Reset/Setup for Total Pass
            resetViews()
            totalPassSetLayout()
            let employmentRate = Double(entity.passedCount) / Double(entity.totalStudentCount) * 100.0
            let passText = String(format: "%.1f", employmentRate.isNaN ? 0.0 : employmentRate)
            passLabel.setJobisText(
                "\(passText)%",
                font: .headLine,
                color: .Primary.blue20
            )

            passTitleLabel.isHidden = false
            passLabel.isHidden = false
            employStatusButton.isHidden = false
            fileImageView.isHidden = false
        }
    }

    private func resetViews() {
        imageView.isHidden = true
        passTitleLabel.isHidden = true
        passLabel.isHidden = true
        employStatusButton.isHidden = true
        fileImageView.isHidden = true

        // Clear image to prevent reuse issues
        imageView.image = nil
    }
}
