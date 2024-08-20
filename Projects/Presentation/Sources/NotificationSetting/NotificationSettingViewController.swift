import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class NotificationSettingViewController: BaseViewController<NotificationSettingViewModel> {
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

    public override func addView() {
        [
//            noticeSwitchButton
            titleLabel,
            allNotificationSwitchView,
            lineView,
            detailMenuLabel,
            noticeSwitchView,
            applicationSwitchView,
            recruitmentSwitchView
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

        noticeSwitchView.snp.makeConstraints {
            $0.height.equalTo(64)
            $0.top.equalTo(detailMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        applicationSwitchView.snp.makeConstraints {
            $0.height.equalTo(64)
            $0.top.equalTo(noticeSwitchView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        recruitmentSwitchView.snp.makeConstraints {
            $0.height.equalTo(64)
            $0.top.equalTo(applicationSwitchView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }

    public override func bind() {
        let input = NotificationSettingViewModel.Input(
            
        )
        let ouput = viewModel.transform(input)
    }

    public override func configureViewController() {
//        viewWillDisappearPublisher.asObservable()
//            .bind {
//                self.setSmallTitle(title: "")
//            }
//            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
//        self.setLargeTitle(title: "알림 설정")
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.hideTabbar()
    }
}
