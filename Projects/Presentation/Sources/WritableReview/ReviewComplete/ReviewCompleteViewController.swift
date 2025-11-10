import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ReviewCompleteViewController: BaseViewController<ReviewCompleteViewModel> {
    private let checkImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Check.image
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    private let descriptionLabel = UILabel().then {
        $0.setJobisText(
            "후기를 작성해 주셔서 감사합니다!\n좋은 결과가 있을 거예요!",
            font: .body,
            color: .GrayScale.gray60
        )
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    public override func addView() {
        [
            checkImageView,
            titleLabel,
            descriptionLabel
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        checkImageView.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }

    public override func bind() {
        let input = ReviewCompleteViewModel.Input(
            viewDidAppear: viewDidAppearPublisher
        )

        let output = viewModel.transform(input)

        output.userName
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] name in
                self?.setTitleText(name: name)
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        view.backgroundColor = .GrayScale.gray10
    }

    private func setTitleText(name: String) {
        let fullText = "\(name)님의\n후기가 작성이 완료됐어요!"
        let attributedString = NSMutableAttributedString(string: fullText)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .center

        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: fullText.count)
        )

        attributedString.addAttribute(
            .font,
            value: UIFont.jobisFont(.pageTitle),
            range: NSRange(location: 0, length: fullText.count)
        )

        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.GrayScale.gray90,
            range: NSRange(location: 0, length: fullText.count)
        )

        titleLabel.attributedText = attributedString
    }
}
