import UIKit
import DesignSystem

class ReviewNavigateView: UIView {
    private let imageView = UIImageView().then {
        $0.image = .jobisIcon(.door)
    }
    private let titleLabel = UILabel().then {
        $0.setJobisText("㈜마이다스아이티 면접 후기를 적어주세요!", font: .description, color: .GrayScale.gray70)
    }
    private let reviewNavigateButton = UIButton(type: .system).then {
        $0.setJobisText("작성하러 가기 →", font: .subHeadLine, color: .Main.blue1)
    }
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
        self.backgroundColor = DesignSystemAsset.Main.bg.color
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        [
            imageView,
            titleLabel,
            reviewNavigateButton
        ].forEach { self.addSubview($0) }

        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
        }
        reviewNavigateButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
        }
    }
}
