import UIKit
import SnapKit
import Then
import DesignSystem

final class CareerNavigationCard: UIButton {
    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.isUserInteractionEnabled = false
    }
    private let cardTitleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private let iconImageView = UIImageView().then {
        $0.transform = CGAffineTransform(rotationAngle: -.pi * 13.38 / 180)
    }
    private var didSetupLayout = false

    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        setupCard()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !didSetupLayout else { return }
        didSetupLayout = true

        [iconImageView, textStackView].forEach(addSubview(_:))
        [cardTitleLabel, descriptionLabel].forEach(textStackView.addArrangedSubview(_:))

        textStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(54)
        }
        iconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        }
    }

    private func setupCard() {
        cardTitleLabel.setJobisText("겨울인턴", font: .headLine, color: .GrayScale.gray90)
        descriptionLabel.setJobisText("체험형 현장실습 보러가기 →", font: .body, color: .GrayScale.gray60)
        iconImageView.image = .jobisIcon(.snowman).resize(size: 120)
    }
}
