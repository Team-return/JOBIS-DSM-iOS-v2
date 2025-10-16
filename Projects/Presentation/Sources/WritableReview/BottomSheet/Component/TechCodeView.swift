import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class TechCodeView: BaseView {
    private let disposeBag = DisposeBag()
    public var area = BehaviorRelay<String>(value: "")
    public let backButtonDidTap = PublishRelay<Void>()

    private let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .GrayScale.gray60
    }

    private let techCodeTitleLabel = UILabel().then {
        $0.setJobisText(
            "지원 직무",
            font: .headLine,
            color: .GrayScale.gray60
        )
    }

    private let progressBarView = ProgressBarView()

    private let searchImageView = UIImageView().then {
        $0.image = .jobisIcon(.searchIcon)
    }
    public let searchTextField = UITextField().then {
        $0.placeholder = "직무를 검색해주세요"
        $0.setPlaceholderColor(.GrayScale.gray60)
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .GrayScale.gray10
        $0.font = UIFont.jobisFont(.body)
        $0.addLeftPadding(size: 44)
        $0.addRightPadding(size: 16)
    }
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    public lazy var techStackView = TechCodeStackView()
    public let addReviewButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }

    public override func addView() {
        [
            backButton,
            techCodeTitleLabel,
            progressBarView,
            searchTextField,
            scrollView,
            addReviewButton
        ].forEach(self.addSubview(_:))
        searchTextField.addSubview(searchImageView)
        scrollView.addSubview(contentStackView)
        [
            techStackView
        ].forEach(self.contentStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(20)
        }

        techCodeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
        }

        progressBarView.snp.makeConstraints {
            $0.top.equalTo(techCodeTitleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(backButton)
            $0.width.equalTo(70)
            $0.height.equalTo(6)
        }

        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.left.equalToSuperview().inset(16)
        }

        searchTextField.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addReviewButton.snp.top).inset(-12)
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }

        addReviewButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    override public func configureView() {
        progressBarView.configure(totalSteps: 4, currentStep: 3)

        backButton.rx.tap
            .bind(to: backButtonDidTap)
            .disposed(by: disposeBag)
    }

    public func updateProgress(currentStep: Int) {
        progressBarView.configure(totalSteps: 4, currentStep: currentStep)
    }
}
