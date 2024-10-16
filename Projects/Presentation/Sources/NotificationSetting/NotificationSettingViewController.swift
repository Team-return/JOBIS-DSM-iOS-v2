import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class NotificationSettingViewController: BaseViewController<NotificationSettingViewModel> {
    private lazy var switchViewArray = [
        noticeSwitchView,
        applicationSwitchView,
        recruitmentSwitchView,
        winterInternSwitchView
    ]

    private let titleLabel = UILabel().then {
        $0.setJobisText(
            "알림 설정",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 2
    }
    private let allNotificationSwitchView = NotificationSectionView().then {
        $0.setTitleLabel(text: "전체 알림")
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .GrayScale.gray40
    }
    private let detailMenuLabel = JobisMenuLabel(text: "세부 알림")
    private let noticeSwitchView = NotificationSectionView().then {
        $0.setTitleLabel(text: "공지사항 알림")
    }
    private let applicationSwitchView = NotificationSectionView().then {
        $0.setTitleLabel(text: "지원서 알림")
    }
    private let recruitmentSwitchView = NotificationSectionView().then {
        $0.setTitleLabel(text: "모집의뢰서 알림")
    }
//    private let interestedSwitchView = NotificationSectionView().then {
//        $0.setTitleLabel(text: "")
//    }
    private let winterInternSwitchView = NotificationSectionView().then {
        $0.setTitleLabel(text: "겨울인턴 알림")
    }
    private lazy var switchViewStackView = UIStackView(arrangedSubviews: switchViewArray).then {
        $0.axis = .vertical
    }

    public override func addView() {
        [
            titleLabel,
            allNotificationSwitchView,
            lineView,
            detailMenuLabel,
            switchViewStackView
        ].forEach(self.view.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        allNotificationSwitchView.snp.makeConstraints {
            $0.height.equalTo(64)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(allNotificationSwitchView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        detailMenuLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        switchViewStackView.snp.makeConstraints {
            $0.top.equalTo(detailMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }

    public override func bind() {
        let input = NotificationSettingViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            allSwitchButtonDidTap: allNotificationSwitchView.clickSwitchButton,
            noticeSwitchButtonDidTap: noticeSwitchView.clickSwitchButton,
            applicationSwitchButtonDidTap: applicationSwitchView.clickSwitchButton,
            recruitmentSwitchButtonDidTap: recruitmentSwitchView.clickSwitchButton,
//            interestSwitchButtonDidTap: interestedSwitchView.clickSwitchButton,
            winterInternSwitchButtonDidTap: winterInternSwitchView.clickSwitchButton
        )

        let output = viewModel.transform(input)

        output.subscribeNoticeState.asObservable()
            .bind(onNext: {
                self.noticeSwitchView.setup(isOn: $0.isSubscribed)
            })
            .disposed(by: disposeBag)

        output.subscribeApplicationState.asObservable()
            .bind(onNext: {
                self.applicationSwitchView.setup(isOn: $0.isSubscribed)
            })
            .disposed(by: disposeBag)

        output.subscribeRecruitmentState.asObservable()
            .bind(onNext: {
                self.recruitmentSwitchView.setup(isOn: $0.isSubscribed)
            })
            .disposed(by: disposeBag)

//        output.subscribeInteresteState.asObservable()
//            .bind(onNext: {
//                self.interestedSwitchView.setup(isOn: $0.isSubscribed)
//            })
//            .disposed(by: disposeBag)

        output.subscribeWinterInternState.asObservable()
            .bind(onNext: {
                self.winterInternSwitchView.setup(isOn: $0.isSubscribed)
            })
            .disposed(by: disposeBag)

        output.allSubscribeState.asObservable()
            .bind(onNext: {
                self.allNotificationSwitchView.setup(isOn: $0)
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        allNotificationSwitchView.clickSwitchButton
            .asObservable()
            .bind(onNext: { [weak self] isOn in
                self?.switchViewArray.forEach {
                    $0.setup(isOn: isOn)
                }
            }).disposed(by: disposeBag)

        noticeSwitchView.clickSwitchButton
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.toggleButton()
            }).disposed(by: disposeBag)

        applicationSwitchView.clickSwitchButton
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.toggleButton()
            }).disposed(by: disposeBag)

        recruitmentSwitchView.clickSwitchButton
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.toggleButton()
            }).disposed(by: disposeBag)

//        interestedSwitchView.clickSwitchButton
//            .asObservable()
//            .bind(onNext: { [weak self] _ in
//                self?.toggleButton()
//            }).disposed(by: disposeBag)

        winterInternSwitchView.clickSwitchButton
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.toggleButton()
            }).disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.hideTabbar()
    }

    private func toggleButton() {
        if (
            noticeSwitchView.switchIsOn &&
            applicationSwitchView.switchIsOn &&
            recruitmentSwitchView.switchIsOn &&
            winterInternSwitchView.switchIsOn
        ) == true {
            self.allNotificationSwitchView.setup(isOn: true)
        } else {
            self.allNotificationSwitchView.setup(isOn: false)
        }
    }
}
