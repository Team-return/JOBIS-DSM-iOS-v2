import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class TechCodeViewController: BaseBottomSheetViewController<TechCodeViewModel> {
    private let collectionViewDidTap = PublishRelay<String>()
    private let addReviewButtonDidTap = PublishRelay<Void>()
    private var appendTechCode = PublishRelay<String>()
    private var resetTechCode = PublishRelay<Void>()

    private let techCodeTitleLabel = UILabel().then {
        $0.setJobisText(
            "기술 스택",
            font: .subBody,
            color: .GrayScale.gray60
        )
    }
//    private let searchTextField = JobisSearchTextField().then {
//        $0.setTextField(placeholder: "검색어를 입력해주세요")
//    }
    private let searchTextField = UITextField().then {
        $0.placeholder = "검색어를 입력해주세요"
        $0.setPlaceholderColor(.GrayScale.gray60)
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .GrayScale.gray10
        $0.font = UIFont.jobisFont(.body)
        $0.addLeftPadding(size: 16)
        $0.addRightPadding(size: 16)
    }
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    private lazy var techStackView = TechCodeStackView().then {
        $0.setTech()
    }
    private let addReviewButton = JobisButton(style: .main).then {
        $0.setText("다음")
    }

    public override func addView() {
        [
            techCodeTitleLabel,
            searchTextField,
            scrollView,
            addReviewButton
        ].forEach(self.contentView.addSubview(_:))
        scrollView.addSubview(contentStackView)
        [
            techStackView
        ].forEach(self.contentStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        techCodeTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        }
        searchTextField.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(techCodeTitleLabel.snp.bottom).offset(24)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }

    public override func bind() {
        let input = TechCodeViewModel.Input(
//            viewWillAppear: viewWillAppearPublisher
            addReviewButtonDidTap: addReviewButtonDidTap
        )

        let output = viewModel.transform(input)

//        output.techList
//            .bind { [weak self] in
//                self?.techStackView.setTech(techList: $0)
//                self?.techStackView.techDidTap = { code in
//                    self?.appendTechCode.accept(code)
//                }
//            }
//            .disposed(by: disposeBag)
    }

    public override func configureViewController() {

        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.setSmallTitle(title: "필터 설정")
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)

        addReviewButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.addReviewButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}
