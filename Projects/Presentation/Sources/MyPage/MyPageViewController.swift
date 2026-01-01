import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class MyPageViewController: BaseReactorViewController<MyPageReactor> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let studentInfoView = StudentInfoView()
    private let editButton = UIButton(type: .system).then {
        $0.setJobisText("수정", font: .subHeadLine, color: .Primary.blue20)
    }
    private let reviewNavigateStackView = ReviewNavigateStackView()
    private let notificationSettingSectionView = NotificationSettingSectionView()
    private let accountSectionView = AccountSectionView()
    private let bugSectionView = BugSectionView()
    private let helpSectionView = HelpSectionView()
    private let selectedImage = PublishRelay<UploadFileModel>()
    private let picker = UIImagePickerController()
    private let logoutPublisher = PublishRelay<Void>()
    private let withdrawalPublisher = PublishRelay<Void>()

    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        [
            studentInfoView,
            editButton,
            reviewNavigateStackView,
            notificationSettingSectionView,
            helpSectionView,
            accountSectionView,
            bugSectionView
        ].forEach { self.contentView.addSubview($0) }
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        studentInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalTo(studentInfoView)
            $0.trailing.equalToSuperview().offset(-28)
        }

        reviewNavigateStackView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(studentInfoView.snp.bottom)
        }

        notificationSettingSectionView.snp.makeConstraints {
            $0.top.equalTo(reviewNavigateStackView.snp.bottom)
//            $0.top.equalTo(studentInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        helpSectionView.snp.makeConstraints {
            $0.top.equalTo(notificationSettingSectionView.snp.bottom)
//            $0.top.equalTo(studentInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        accountSectionView.snp.makeConstraints {
            $0.top.equalTo(helpSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        bugSectionView.snp.makeConstraints {
            $0.top.equalTo(accountSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-60)
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher.asObservable()
            .map { MyPageReactor.Action.fetchMyPageData }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reviewNavigateStackView.reviewNavigateButtonDidTap
            .map { MyPageReactor.Action.reviewNavigateButtonDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selectedImage
            .map { MyPageReactor.Action.profileImageSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        notificationSettingSectionView.getSelectedItem(type: .notificationSetting)
            .map { _ in MyPageReactor.Action.notificationSettingDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        helpSectionView.getSelectedItem(type: .announcement)
            .map { _ in MyPageReactor.Action.helpDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bugSectionView.getSelectedItem(type: .reportBug)
            .map { _ in MyPageReactor.Action.bugReportDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        accountSectionView.getSelectedItem(type: .interestField)
            .map { _ in MyPageReactor.Action.interestFieldDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        accountSectionView.getSelectedItem(type: .changePassword)
            .do(onNext: { [weak self] _ in
                self?.hideTabbar()
            })
            .map { _ in MyPageReactor.Action.changePasswordDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        logoutPublisher
            .map { MyPageReactor.Action.logout }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        withdrawalPublisher
            .map { MyPageReactor.Action.withdrawal }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.studentInfo }
            .compactMap { $0 }
            .bind(onNext: { [weak self] studentInfo in
                self?.studentInfoView.setStudentInfo(
                    profileImageUrl: studentInfo.profileImageUrl,
                    gcn: studentInfo.studentGcn,
                    name: studentInfo.studentName,
                    department: studentInfo.department.localizedString()
                )
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.writableReviewList }
            .bind(onNext: { [weak self] list in
                self?.reviewNavigateStackView.setList(writableReviewCompanylist: list)
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.picker.delegate = self
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.showTabbar()
            })
            .disposed(by: disposeBag)

        self.accountSectionView.getSelectedItem(type: .logout)
            .asObservable()
            .subscribe(onNext: {_ in
                AlertBuilder(viewController: self)
                    .setTitle("JOBIS에서 로그아웃 하시겠어요?")
                    .setMessage("JOBIS에서 로그아웃 하면,\n로그인 할 때 까지 사용하지 못해요")
                    .addActionConfirm("로그아웃") {
                        self.withdrawalPublisher.accept(())
                    }
                    .show()
            })
            .disposed(by: disposeBag)

        self.accountSectionView.getSelectedItem(type: .withDraw)
            .asObservable()
            .subscribe(onNext: {_ in
                AlertBuilder(viewController: self)
                    .setTitle("JOBIS에서 탈퇴하시겠어요?")
                    .setMessage("JOBIS에서 탈퇴하면,\n다시 가입 할 때 까지 사용하지 못해요")
                    .addActionConfirm("회원탈퇴") {
                        self.logoutPublisher.accept(())
                    }
                    .show()
            })
            .disposed(by: disposeBag)

        self.editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openLibrary()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setLargeTitle(title: "마이페이지")
    }
}

extension MyPageViewController: UIImagePickerControllerDelegate {
     func openLibrary() {
         picker.sourceType = .photoLibrary
         present(picker, animated: true, completion: nil)
     }
 }

 extension MyPageViewController: UINavigationControllerDelegate {
     public func imagePickerController(
         _ picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
     ) {
         if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             guard let imageData = image.pngData() else { return }
             self.studentInfoView.updateProfileImage(image: image)
             self.selectedImage.accept(.init(file: imageData, fileName: "profile.png"))
             dismiss(animated: true, completion: nil)
         }
     }
 }
