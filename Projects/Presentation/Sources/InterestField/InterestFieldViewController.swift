import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterestFieldViewController: BaseViewController<InterestFieldViewModel> {
    private let viewAppearRelay = PublishRelay<Void>()
    private let interestFieldTitleLabel = UILabel().then {
        $0.setJobisText(
            "님의\n관심사를 선택해주세요",
            font: .smallBody,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
    }

    private let interestFieldDescriptionLabel = UILabel().then {
        $0.setJobisText(
            "관심사에 맞는 모집 의뢰서가 업로드되면 알림을 드립니다!",
            font: .description,
            color: .GrayScale.gray80
        )
    }

    private let majorCollectionView = InterestFieldCollectionView()

    private let selectButton = JobisButton(style: .main).then {
        $0.setText("관심 분야를 선택해 주세요!")
        $0.isEnabled = false
    }

    public override func addView() {
        [
            interestFieldTitleLabel,
            interestFieldDescriptionLabel,
            majorCollectionView,
            selectButton
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        interestFieldTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        interestFieldDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(interestFieldTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
        majorCollectionView.snp.makeConstraints {
            $0.top.equalTo(interestFieldDescriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(selectButton.snp.top).offset(-24)
        }
        selectButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func configureNavigation() {
        setSmallTitle(title: "관심사 설정")
        self.navigationItem.largeTitleDisplayMode = .never
        self.hideTabbar()
    }

    public override func bind() {
        let input = InterestFieldViewModel.Input(
            viewAppear: viewAppearRelay,
            selectButtonDidTap: selectButton.rx.tap.asSignal(),
            selectedInterests: majorCollectionView.selectedInterests
        )

        let output = viewModel.transform(input)

        rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .bind(to: viewAppearRelay)
            .disposed(by: disposeBag)

        output.availableInterests
            .subscribe(onNext: { [weak self] list in
                self?.majorCollectionView.updateInterests(list)
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            output.availableInterests,
            output.userSavedInterests
        )
        .subscribe(onNext: { [weak self] (availableInterests, userInterests) in
            self?.majorCollectionView.preSelectInterests(userInterests)
        })
        .disposed(by: disposeBag)

        output.selectedInterests
            .map { $0.count }
            .distinctUntilChanged()
            .drive(onNext: { [weak self] count in
                if count == 0 {
                    self?.selectButton.setText("관심 분야를 선택해 주세요!")
                    self?.selectButton.isEnabled = false
                } else {
                    self?.selectButton.setText("\(count)개 선택")
                    self?.selectButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
    }
}
