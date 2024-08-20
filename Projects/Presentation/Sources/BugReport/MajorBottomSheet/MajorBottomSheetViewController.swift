import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class MajorBottomSheetViewController: BaseBottomSheetViewController<MajorBottomSheetViewModel> {
    private let list: [String] = ["iOS", "Android", "Server", "Web", "전체"]
    public var dismiss: ((String) -> Void)?
    private let majorTypeStackViewDidTap = PublishRelay<Void>()

    private let majorSelectMenuLabel = JobisMenuLabel(text: "분야 선택")
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    private lazy var majorTypeStackView = MajorTypeStackView()

    public override func addView() {
        [
            majorSelectMenuLabel,
            scrollView
        ].forEach(self.contentView.addSubview(_:))
        scrollView.addSubview(contentStackView)
        [
            majorTypeStackView
        ].forEach(self.contentStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        majorSelectMenuLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(majorSelectMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }

    public override func bind() {
        let input = MajorBottomSheetViewModel.Input(
            majorTypeStackViewDidTap: self.majorTypeStackViewDidTap
        )

        _ = viewModel.transform(input)
    }

    public override func configureViewController() {
        majorTypeStackView.majorDidTap.asObservable()
            .subscribe(onNext: {
                self.viewModel.majorType.accept($0)

                self.dismiss?(
                    self.viewModel.majorType.value
                )

                self.majorTypeStackViewDidTap.accept(())
            })
            .disposed(by: disposeBag)

        viewDidLoadPublisher.asObservable()
            .bind {
                self.hideTabbar()
            }
            .disposed(by: disposeBag)

        self.majorTypeStackView.setTech(majorList: list)
    }
}
