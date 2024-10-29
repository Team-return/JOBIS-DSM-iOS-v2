import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

final class BannerCollectionViewCell: BaseCollectionViewCell<FetchBannerEntity> {
    static let identifier = "BannerCollectionViewCell"

    private let currentYear = Date()
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    private lazy var passTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setJobisText(
            "\(Int(currentYear.toStringFormat("yyyy"))! - 2016)기 대마고\n학생들의 취업률",
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
    private let prePassCountTitleLabel = UILabel().then {
        $0.setJobisText(
            "현재",
            font: .subHeadLine,
            color: .GrayScale.gray60
        )
    }
    private let sufPassCountTitleLabel = UILabel().then {
        $0.setJobisText(
            "명이 취업했어요",
            font: .subHeadLine,
            color: .GrayScale.gray60
        )
    }
    private let passCountLabel = UILabel().then {
        $0.setJobisText(
            " - ",
            font: .subHeadLine,
            color: .GrayScale.gray70
        )
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
            prePassCountTitleLabel,
            sufPassCountTitleLabel,
            passCountLabel,
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

        prePassCountTitleLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(24)
        }

        passCountLabel.snp.makeConstraints {
            $0.top.equalTo(prePassCountTitleLabel.snp.top)
            $0.leading.equalTo(prePassCountTitleLabel.snp.trailing).offset(4)
        }

        sufPassCountTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalTo(passCountLabel.snp.trailing).offset(4)
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

    override func adapt(model: FetchBannerEntity) {
        setLayout()
        self.imageView.setJobisImage(urlString: model.bannerURL)
    }

    func totalPassAdapt(model: TotalPassStudentEntity) {
        totalPassSetLayout()
        let employmentRate = Double(model.passedCount) / Double(model.totalStudentCount) * 100.0
        let passText = String(format: "%.1f", employmentRate)
        passLabel.setJobisText(
            "\(passText)%",
            font: .headLine,
            color: .Primary.blue20
        )

        passCountLabel.setJobisText(
            "\(model.passedCount)/\(model.totalStudentCount)",
            font: .subHeadLine,
            color: .GrayScale.gray70
        )
    }
}
